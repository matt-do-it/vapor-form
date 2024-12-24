import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: LoginController())
    
    try app.register(collection: ContactFormController())
    try app.register(collection: ContactFormAdminController())
/*
    let protected = app
        .grouped(AuthPayload.authenticator(), AuthPayload.guardMiddleware())
    
    try protected.register(collection: ContactFormAdminController())
 */}
