import Vapor
import Smtp

struct ContactFormController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contact = routes.grouped("api", "contact")
        
        contact.post(use: index)
     }

    @Sendable func index(req: Request) async throws -> Response {
        try ContactFormRequest.validate(content: req)
        
        let contact = try req.content.decode(ContactFormRequest.self)

        let email = try! Email(
            from: EmailAddress(address: "mail@matt-herold.de", name: "Matt"),
            to: [EmailAddress(address: "mail@matt-herold.de", name: "Matt")],
            subject: "You got a new contact inquiry",
            body: "Name: " +
                contact.name + "\n" +
            "Email: " +
            contact.email + "\n" +
            "Message: " +
            contact.message + "\n" +
            "---\n" +
            "Sent by vapor"
        )
        
        try await req.application.smtp.send(email, eventLoop: nil)
        
        let response = Response(status: .ok)
        return response
    }
}
