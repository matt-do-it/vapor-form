import Vapor

struct JSONQueryParams : Content {
    var page : JSONQueryPageParams?
    var sort : String?
    var filter : String?
}
