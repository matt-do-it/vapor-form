import Vapor

struct LoginFormRequest: Content {
    var username: String
    var password: String
 }

extension LoginFormRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: !.empty)
    }
}

