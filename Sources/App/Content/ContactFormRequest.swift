import Vapor

struct ContactFormRequest: Content {
    var name: String
    var email: String
    var message: String
    
    init(model: ContactFormModel) {
        self.name = model.name
        self.email = model.email
        self.message = model.message
    }
    
    func updateModel(model: ContactFormModel) {
        model.name = self.name
        model.email = self.email
        model.message = self.message
    }
}

extension ContactFormRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("message", as: String.self, is: !.empty)
    }
}

