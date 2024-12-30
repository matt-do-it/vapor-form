import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders


struct ShowTopicsCommand: AsyncCommand {
    struct Signature: CommandSignature { }
    
    var help: String {
        "List all topics"
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let pubSubClient = try await PubSubClient(eventLoopGroup: context.application.eventLoopGroup)
        
        defer {
            try! pubSubClient.close()
        }
        
        let response = try await pubSubClient.listTopics()
       
        response.topics.forEach { topic in
            print(topic.name)
        }
    }
}
