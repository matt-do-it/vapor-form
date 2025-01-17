import Vapor

struct ContactFormDTOAttributes: JSONAPIAttributes {
    var name: String
    var email: String
    var message: String
    
    var createdAt : Date?
    var updatedAt : Date?
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case message
        case createdAt = "created-at"
        case updatedAt = "updated-at"
    }
}
