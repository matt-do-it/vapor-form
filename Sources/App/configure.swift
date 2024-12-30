import Vapor
import Smtp
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    app.smtp.configuration.hostname = Environment.get("SMTP_HOST")!
    app.smtp.configuration.port = Int(Environment.get("SMTP_PORT")!)!
    app.smtp.configuration.signInMethod = .credentials(
        username: Environment.get("SMTP_USER")!,
        password: Environment.get("SMTP_PASSWORD")!
    )
    app.smtp.configuration.secure = .startTls
    
    var configuration = TLSConfiguration.makeClientConfiguration()
    configuration.certificateVerification = .none
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: Environment.get("PG_HOST")!,
                port: Int(Environment.get("PG_PORT")!)!,
                username: Environment.get("PG_USER")!,
                password: Environment.get("PG_PASSWORD")!,
                database: Environment.get("PG_DATABASE")!,
                tls: .require(try NIOSSLContext(configuration: configuration))
            )
        ),
        as: .psql
    )
    
    app.migrations.add(ContactFormMigration())
    app.migrations.add(UserModelMigration())
    
   try await app.autoMigrate()
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
    
    app.asyncCommands.use(ShowTopicsCommand(), as: "show-topics")
    app.asyncCommands.use(SampleSubmissionCommand(), as: "send-message")
    app.asyncCommands.use(SampleReadCommand(), as: "read-message")

    await app.jwt.keys.add(hmac: "secret", digestAlgorithm: .sha256)
    
    try routes(app)
  }

extension Application {
    var hostName : String {
        get {
            return "https://api.mattherold.de"
        }
    }
}
