import Fluent
import Vapor


struct ContactFormMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("contact_form")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("message", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) async throws {
    }
}
