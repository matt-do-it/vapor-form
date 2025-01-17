import Vapor

struct JSONAPIMultiResponse<A, R> : Content where A : JSONAPIAttributes, R : JSONAPIRelationship {
    var links : JSONAPILinksResponse
    var data : [JSONAPIObject<A, R>]
    var meta: JSONAPIMetaResponse
}
