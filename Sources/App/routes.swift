import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: LoginController())
    
    try app.register(collection: ContactFormController())

    let protected = app
        .grouped(AuthPayload.authenticator(), AuthPayload.guardMiddleware())
    
    try protected.register(collection: ContactFormAdminController())
 }
