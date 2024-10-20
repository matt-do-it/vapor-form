import Vapor
import Smtp

public func configure(_ app: Application) async throws {
    app.smtp.configuration.hostname = Environment.get("SMTP_HOST")!
    app.smtp.configuration.port = Int(Environment.get("SMTP_PORT")!)!
    app.smtp.configuration.signInMethod = .credentials(
        username: Environment.get("SMTP_USER")!,
        password: Environment.get("SMTP_PASSWORD")!
    )
    app.smtp.configuration.secure = .startTls
    
    try routes(app)
}

