import Vapor

struct JSONAPISingleRequest<A, R> : Content where A : JSONAPIAttributes, R : JSONAPIRelationship {
    var data : JSONAPIObject<A, R>
}
