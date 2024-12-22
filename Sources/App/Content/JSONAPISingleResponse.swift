import Vapor

struct JSONAPISingleResponse<T> : Content where T : Content {
    var data : JSONAPIObject<T>
}
