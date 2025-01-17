//
//  Client.swift
//  VaporForm
//
//  Created by Matt Herold on 29.12.24.
//
import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders

class PubSubClient {
    let privateKey : JWT.Insecure.RSA.PrivateKey
    let privateKeyId : String
    
    let issuer: String
    let project: String
    
    let keyCollection = JWTKeyCollection()
    
    let channel: GRPCChannel
    
    init(eventLoopGroup: EventLoopGroup) async throws {
        privateKey = try Insecure.RSA.PrivateKey(pem: Environment.get("PUBSUB_PRIVATE_KEY")!)
        privateKeyId = Environment.get("PUBSUB_PRIVATE_KEY_ID")!
        issuer = Environment.get("PUBSUB_ISSUER")!
        project = Environment.get("PUBSUB_PROJECT")!
        
        await keyCollection.add(rsa: privateKey, digestAlgorithm: .sha256, kid: JWKIdentifier(string: privateKeyId))
        
        let conf = GRPCTLSConfiguration.makeClientDefault(compatibleWith: eventLoopGroup)
        channel = try GRPCChannelPool.with(
            target: .host("pubsub.googleapis.com"),
            transportSecurity: .tls(conf),
            eventLoopGroup: eventLoopGroup
        )
    }
    
    func createToken() async throws -> String {
        let now = Date.now
        
        let s = GoogleAuthPayload(
            iss: IssuerClaim(value: issuer),
            scope: "https://www.googleapis.com/auth/pubsub",
            aud: "https://pubsub.googleapis.com/",
            sub: .init(value: issuer),
            email: .init(value: issuer),
            exp: .init(value: now.addingTimeInterval(3600)),
            iat: .init(value: now)
        )
        
        return try await keyCollection.sign(s)
    }
    
    func callOptions() async throws -> CallOptions {
        var hpackHeaders = HPACKHeaders()
        try await hpackHeaders.add(name: "Authorization", value: "Bearer \(createToken())")
        
        return CallOptions(customMetadata: hpackHeaders)
    }
    
    func close() throws {
        try channel.close().wait()
    }
    
    func listTopics() async throws -> Google_Pubsub_V1_ListTopicsResponse {
        let client = Google_Pubsub_V1_PublisherAsyncClient(channel: channel)
        
        var request = Google_Pubsub_V1_ListTopicsRequest()
        request.project = Environment.get("PUBSUB_PROJECT")!
        
        return try await client.listTopics(request, callOptions: callOptions())
    }
    
    func sendMessage(contact: ContactFormDTOAttributes) async throws {
        let client = Google_Pubsub_V1_PublisherAsyncClient(channel: channel)
        
        var publishRequest = Google_Pubsub_V1_PublishRequest()
        publishRequest.topic = Environment.get("PUBSUB_TOPIC")!
        
        var message = Google_Pubsub_V1_PubsubMessage()
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        message.data = try encoder.encode(contact)
        
        publishRequest.messages = [message]
        
        let _ = try await client.publish(publishRequest, callOptions: callOptions())
    }
    
    func readMessagesStream() -> AsyncThrowingStream<Google_Pubsub_V1_ReceivedMessage, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                let client = Google_Pubsub_V1_SubscriberAsyncClient(channel: channel)
                
                var p = Google_Pubsub_V1_StreamingPullRequest()
                p.subscription = Environment.get("PUBSUB_SUBSCRIPTION")!
                p.streamAckDeadlineSeconds = 10
                
                let call = try await client.makeStreamingPullCall(callOptions: callOptions())
                
                try await call.requestStream.send(p)
                
                Task {
                    do {
                        for try await response in call.responseStream {
                            for receivedMessage in response.receivedMessages {
                                continuation.yield(receivedMessage)
                            }
                        }
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
                
                Task {
                    for i in stride(from: 0, through: 90, by: 1) {
                        try await Task.sleep(nanoseconds: 10_000_000_000)
                        print("Sending keep-alive")
                        try await call.requestStream.send(Google_Pubsub_V1_StreamingPullRequest())
                    }
                    print("Finishing stream")
                    call.requestStream.finish()
                }
                
                // Stream-Status überprüfen
                let _ = await call.status
                continuation.finish() // Signal the end of the sequence
            }
        }
    }
    
    func readMessages(maxMessages: Int32) async throws -> [Google_Pubsub_V1_ReceivedMessage] {
        let client = Google_Pubsub_V1_SubscriberAsyncClient(channel: channel)
        
        var p = Google_Pubsub_V1_PullRequest()
        p.subscription = Environment.get("PUBSUB_SUBSCRIPTION")!
        p.maxMessages = maxMessages
        
        let call = try await client.pull(p, callOptions: callOptions())
        
        return call.receivedMessages
    }
    
    func acknowledgeMessages(messages: [Google_Pubsub_V1_ReceivedMessage]) async throws {
        if (messages.count > 0) {
            let client = Google_Pubsub_V1_SubscriberAsyncClient(channel: channel)
            
            var p = Google_Pubsub_V1_AcknowledgeRequest()
            p.subscription = Environment.get("PUBSUB_SUBSCRIPTION")!
            p.ackIds = messages.map(\.ackID)
            
            let _ = try await client.acknowledge(p, callOptions: callOptions())
        }
    }
}
