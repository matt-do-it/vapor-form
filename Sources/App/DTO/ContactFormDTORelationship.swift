import Vapor

struct ContactFormDTORelationship: JSONAPIRelationship {
    var form: JSONAPIRelationshipSingle?
}
