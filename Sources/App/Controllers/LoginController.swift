import Vapor
import Smtp
import GRPC
import Mustache
import JWT
import FluentKit

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contact = routes.grouped("api", "login")
        
        contact.post(use: index)
    }
    
    @Sendable func index(req: Request) async throws -> [String: String] {
        let login = try req.content.decode(LoginFormRequest.self)

        guard let user = try await UserModel
            .query(on: req.db)
            .filter(\.$email == login.username)
            .first() else {
            throw Abort(.unauthorized)
        }
        
        guard try user.verify(password: login.password) else {
        throw Abort(.unauthorized)
        }
        
            let payload = AuthPayload(
                subject: SubjectClaim(value: user.email),
                    expiration: .init(value: .distantFuture)
                )
            
        return try await ["user" : user.email, "token": req.jwt.sign(payload)]
        
        
        
    }
}
