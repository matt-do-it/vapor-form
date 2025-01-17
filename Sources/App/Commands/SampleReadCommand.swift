import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders


struct SampleReadCommand: AsyncCommand {
    struct Signature: CommandSignature { }
    
    var help: String {
        "Read sample message"
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let pubSubClient = try await PubSubClient(eventLoopGroup: context.application.eventLoopGroup)
        
        defer {
            try! pubSubClient.close()
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let messages = try await pubSubClient.readMessages(maxMessages: 10)
        for random in messages {
            do {
                let message = try jsonDecoder.decode(ContactFormDTOAttributes.self, from: random.message.data)
                print(message)
            } catch {
                print("error on decode")
            }
        }
        
        try await pubSubClient.acknowledgeMessages(messages: messages)

        print("Streaming-Pull abgeschlossen.")
    }
}
