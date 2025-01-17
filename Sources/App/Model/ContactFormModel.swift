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

protocol JSONAPIConvertible {
    associatedtype Attributes : JSONAPIAttributes
    associatedtype Relationships : JSONAPIRelationship
        
    func jsonAPIObject() -> JSONAPIObject<Attributes, Relationships>
    func update(jsonAPIObject: JSONAPIObject<Attributes, Relationships>)
}

extension ContactFormModel : JSONAPIConvertible {
    typealias Attributes = ContactFormDTOAttributes
    typealias Relationship = ContactFormDTORelationship

    func jsonAPIObject() -> JSONAPIObject<ContactFormDTOAttributes, ContactFormDTORelationship> {
        return JSONAPIObject(type: "contact", id: self.id!, attributes: ContactFormDTOAttributes(name: self.name,
                                                                                              email: self.email,
                                                                                              message: self.message,
                                                                                              createdAt: self.createdAt,
                                                                                              updatedAt: self.updatedAt),
                             relationships: ContactFormDTORelationship(form: nil))
    }
    
    func update(jsonAPIObject: JSONAPIObject<ContactFormDTOAttributes, ContactFormDTORelationship>) {
        let attributes = jsonAPIObject.attributes
        
        self.name = attributes.name
        self.email = attributes.email
        self.message = attributes.message
    }
}
