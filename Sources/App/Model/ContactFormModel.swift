import Fluent
import Vapor

final class ContactFormModel: Model {
    // Name of the table or collection.
    static let schema = "contact_form"

    // Unique identifier for this Planet.
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "message")
    var message: String

    @Field(key: "created_at")
    var createdAt: Date

    @Field(key: "updated_at")
    var updatedAt: Date

    init() { }
    
    init(request: ContactFormRequest) {
        self.name = request.name
        self.email = request.email
        self.message = request.message
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
