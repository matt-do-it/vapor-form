import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ContactFormController())
    
    let protected = app.grouped(AuthDialogMiddleware())

        .grouped(UserModel.authenticator())
        .grouped(UserModel.guardMiddleware())
    
    try protected.register(collection: ContactFormAdminController())
 }

struct AuthDialogMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapErrorThrowing { error in
            switch error {
            case let abort as AbortError:
                guard abort.status == .unauthorized else {
                    throw error
                }

                let response = Response(status: .unauthorized, headers: [:])
                response.headers.replaceOrAdd(name: "WWW-Authenticate", value: "Basic realm=\"Dev\"")
                return response
            default:
                throw error
            }
        }
    }
}
