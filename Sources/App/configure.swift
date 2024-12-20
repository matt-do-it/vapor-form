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
    try await app.autoMigrate()
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    try routes(app)
  }

