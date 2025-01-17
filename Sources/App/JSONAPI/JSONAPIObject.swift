import Vapor

struct JSONAPIObject<A, R>: Content where A : JSONAPIAttributes, R : JSONAPIRelationship {
    var type: String
    var id: UUID
    
    var attributes: A
    var relationships: R?
}
