//
//  SampleSubmissionCommand.swift
//  VaporForm
//
//  Created by Matt Herold on 29.12.24.
//

import Vapor
import GRPC
import JWT
import NIO
import struct NIOHPACK.HPACKHeaders


struct SampleSubmissionCommand: AsyncCommand {
    struct Signature: CommandSignature { }
    
    var help: String {
        "Submit sample message"
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let pubSubClient = try await PubSubClient(eventLoopGroup: context.application.eventLoopGroup)
        
        defer {
            try! pubSubClient.close()
        }
        
        try await pubSubClient.sendMessage(contact: ContactFormDTO(name: "Matt", email: "mattherold@icloud.com", message: "Hey"))
    }
}
