import Vapor

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

