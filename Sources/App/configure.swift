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
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    try routes(app)
  }

