import Vapor
import Smtp
import Mustache
import GRPC

struct ContactFormController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contact = routes.grouped("api", "contact")
        
        contact.get(use: index)
        contact.post(use: post)
     }

    @Sendable func index(req: Request) async throws -> Response {
        let response = Response(status: .ok)
        return response
    }
    
    @Sendable func post(req: Request) async throws -> Response {
        try ContactFormRequest.validate(content: req)
        
        let contact = try req.content.decode(ContactFormRequest.self)

        let templateBuffer = try await req.fileio.collectFile(at: "Templates/ContactForm.mustache")
        let templateString = String(buffer: templateBuffer)
        
        let template = try Mustache.Template(string: templateString)
        let rendered = try template.render(contact)
        
        // Safe to database
        let model = ContactFormModel(request: contact)
        try await model.save(on: req.db)
        
        let email = try! Email(
            from: EmailAddress(address: "mail@matt-herold.de", name: "Matt"),
            to: [EmailAddress(address: "mail@matt-herold.de", name: "Matt")],
            subject: "You got a new contact inquiry",
            body: rendered
        )
        
        try await req.application.smtp.send(email, eventLoop: nil)
        /*
        let channel = try GRPCChannelPool.with(
            target: .host("localhost", port: self.port),
            transportSecurity: .plaintext,
            eventLoopGroup: req.application.eventLoopGroup
          )
        defer {
              try! channel.close().wait()
            }
        
        var publishRequest = Google_Pubsub_V1_PublishRequest()
        publishRequest.topic = "contact"
        
        var message = Google_Pubsub_V1_PubsubMessage()
        message.data = contact.post.data
        
        let client = Google_Pubsub_V1_PublisherClient(channel: channel)
        client.publish(req: .init(topic: "contact-form", messages: [.init(data: contact.post.data)]))
        */
        let response = Response(status: .ok)
        return response
    }
}
