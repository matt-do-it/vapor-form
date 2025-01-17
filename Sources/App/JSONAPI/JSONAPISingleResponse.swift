import Vapor

struct JSONAPISingleResponse<A, R> : Content where A : JSONAPIAttributes, R : JSONAPIRelationship {
    var data : JSONAPIObject<A, R>
}
