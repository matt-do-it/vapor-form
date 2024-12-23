import Vapor
import Smtp
import GRPC
import Mustache

struct ContactFormAdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contact = routes.grouped("api", "admin", "contacts")
        
        contact.get(use: index)
        contact.get(":id", use: get)
    }
    
    @Sendable func index(req: Request) async throws -> JSONAPIMultiResponse<ContactFormRequest> {
        let model = try await ContactFormModel.query(on: req.db)
            .all()
        
        let data = model.map { t in
            JSONAPIObject(type: "contact",
                          id: t.id!,
                          attributes: ContactFormRequest(model: t))
        }
        return JSONAPIMultiResponse(data: data)
    }
    
    @Sendable func get(req: Request) async throws -> JSONAPISingleResponse<ContactFormRequest> {
        guard let id = req.parameters.get("id") else {
            throw Abort(.preconditionFailed)
        }
        guard let uuid = UUID(uuidString: id) else {
            throw Abort(.preconditionFailed)
        }
        
        guard let model = try await ContactFormModel.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let data = JSONAPIObject(type: "contact",
                                 id: model.id!,
                                 attributes: ContactFormRequest(model: model))
        
        
        return JSONAPISingleResponse(data: data)
    }
    
    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id") else {
            throw Abort(.preconditionFailed)
        }
        guard let uuid = UUID(uuidString: id) else {
            throw Abort(.preconditionFailed)
        }
        
        guard let model = try await ContactFormModel.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await model.delete(on: req.db)
        
        return .ok
    }
    
    func update(req: Request) async throws -> JSONAPISingleResponse<ContactFormRequest> {
        guard let id = req.parameters.get("id") else {
            throw Abort(.preconditionFailed)
        }
        guard let uuid = UUID(uuidString: id) else {
            throw Abort(.preconditionFailed)
        }
        
        guard let model = try await ContactFormModel.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateRequest = try req.content.decode(JSONAPISingleRequest<ContactFormRequest>.self)
        
        updateRequest.data.attributes.updateModel(model: model)
        
        try await model.save(on: req.db)
        
        let data = JSONAPIObject(type: "contact",
                                 id: model.id!,
                                 attributes: ContactFormRequest(model: model))
        
        
        return JSONAPISingleResponse(data: data)
    }

    func create(req: Request) async throws -> JSONAPISingleResponse<ContactFormRequest> {
        let model = ContactFormModel()
        
        let createRequest = try req.content.decode(JSONAPISingleRequest<ContactFormRequest>.self)
        
        createRequest.data.attributes.updateModel(model: model)

        try await model.save(on: req.db)
        
        let data = JSONAPIObject(type: "contact",
                                 id: model.id!,
                                 attributes: ContactFormRequest(model: model))
        
        
        return JSONAPISingleResponse(data: data)
    }

}
