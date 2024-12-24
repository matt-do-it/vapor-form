import Vapor

struct ContactFormDTO: Content {
    var name: String
    var email: String
    var message: String
    
    var createdAt : Date
    var updatedAt : Date
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case message
        case createdAt = "created-at"
        case updatedAt = "updated-at"
    }

    
    init(model: ContactFormModel) {
        self.name = model.name
        self.email = model.email
        self.message = model.message
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
    
    func updateModel(model: ContactFormModel) {
        model.name = self.name
        model.email = self.email
        model.message = self.message
        model.createdAt = self.createdAt
        model.updatedAt = self.updatedAt
    }
}

