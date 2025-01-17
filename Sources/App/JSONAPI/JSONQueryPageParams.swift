import Vapor

struct JSONQueryPageParams : Content {
    var offset : Int?
    var limit : Int?
}
