import Vapor
import Smtp
import GRPC
import Mustache

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
        
        let template = try Mustache.MustacheTemplate(string: templateString)
        let rendered = template.render(contact)
        
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
        
        let form = ContactFormDTO(name: contact.name, email: contact.email, message: contact.message)
        
        let client = try await PubSubClient(eventLoopGroup: req.application.eventLoopGroup)
        try await client.sendMessage(contact: form)
        
        let response = Response(status: .ok)
        return response
    }
}
