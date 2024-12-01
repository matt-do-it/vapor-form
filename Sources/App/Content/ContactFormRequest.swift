import Vapor
import Mustache

struct ContactFormRequest: Content {
    var name: String
    var email: String
    var message: String
}

extension ContactFormRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("message", as: String.self, is: !.empty)
    }
}

extension ContactFormRequest: MustacheBoxable {
    var mustacheBox: Mustache.MustacheBox {
        return Box(["name": self.name,
                    "email": self.email,
                    "message": self.message])
    }
}

