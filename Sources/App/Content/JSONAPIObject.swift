import Vapor

struct JSONAPIObject<T>: Content where T : Content {
    var type: String
    var id: UUID
    var attributes: T
}
