import Vapor
import Smtp
import GRPC
import Mustache
import JWT
import FluentKit

struct LoginController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let loginGroup = routes.grouped("api", "login")
        loginGroup.post(use: login)
        
        let verifyGroup = routes.grouped("api", "verify")
        verifyGroup.post(use: verify)
    }
    
    @Sendable func login(req: Request) async throws -> [String: String] {
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
        
        return try await ["user" : user.email,
                          "name": user.name,
                          "token": req.jwt.sign(payload)]
    }
    
    @Sendable func verify(req: Request) async throws -> [String: String] {
        let payload = try await req.jwt.verify(as: AuthPayload.self)
        
        let email = payload.subject.value
        
        guard let user = try await UserModel
            .query(on: req.db)
            .filter(\.$email == email)
            .first() else {
            throw Abort(.unauthorized)
        }
        
        return ["user" : user.email,
                "name": user.name]
    }
}
