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
        
        for try await random in pubSubClient.readMessages() {
            print(random)
        }
        
        print("Streaming-Pull abgeschlossen.")
    }
}
