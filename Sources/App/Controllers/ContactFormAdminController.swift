import Vapor
import Smtp
import GRPC
import Mustache
import FluentKit

struct ContactFormAdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contacts = routes.grouped("api", "admin", "contacts")
        
        contacts.post(use: create)
        contacts.get(use: index)

        contacts.group(":id") { contact in
            contact.get(use: get)
            contact.patch(use: update)
            contact.delete(use: delete)
         }
    }
    
    @Sendable func index(req: Request) async throws -> JSONAPIMultiResponse<ContactFormDTO> {
        
        let params = try req.query.decode(JSONQueryParams.self)
        
        var query = ContactFormModel.query(on: req.db)

        if let filter = params.filter, !filter.isEmpty {
            query = query.group(.or) { group in
                group.filter(\.$name ~~ filter)
                    .filter(\.$email ~~ filter)
                    .filter(\.$message ~~ filter)
            }
        }
        
        if let sort = params.sort, !sort.isEmpty {
            var valuePath = sort
            var direction : DatabaseQuery.Sort.Direction = .ascending
            
            if sort.first == "-" {
                valuePath = String(sort.dropFirst(1))
                direction = .descending
            }
            if (valuePath == "email") {
                query = query.sort(\.$email, direction)
            }
            if (valuePath == "name") {
                query = query.sort(\.$name, direction)
            }
            if (valuePath == "message") {
                query = query.sort(\.$message, direction)
            }
            if (valuePath == "createdAt") {
                query = query.sort(\.$createdAt, direction)
            }
        }
        query = query.sort(\ContactFormModel.$createdAt, .descending)
            .sort(\ContactFormModel.$id)
        
        
        
        let offset = params.page?.offset ?? 0
        let limit = max(min(params.page?.limit ?? 10, 1000), 1)
        
        
        let modelData = try await query
            .offset(offset)
            .limit(limit)
            .all()
        
        let data = modelData.map { t in
            JSONAPIObject(type: "contact",
                          id: t.id!,
                          attributes: ContactFormDTO(model: t))
        }
        
        
        let count = try await ContactFormModel.query(on: req.db)
            .count()
        
        var selfLinkComponents = URLComponents(string: req.application.hostName)!
        selfLinkComponents.path = "/api/admin/contacts"
        selfLinkComponents.queryItems = [
            URLQueryItem(name: "page[offset]", value: String(offset)),
            URLQueryItem(name: "page[limit]", value: String(limit))
        ]
        let selfLink = selfLinkComponents.url!

        var firstLinkComponents = URLComponents(string: req.application.hostName)!
        firstLinkComponents.path = "/api/admin/contacts"
        let firstOffset = 0
        firstLinkComponents.queryItems = [
            URLQueryItem(name: "page[offset]", value: String(firstOffset)),
            URLQueryItem(name: "page[limit]", value: String(limit))
        ]
        let firstLink = firstLinkComponents.url!

        var lastLinkComponents = URLComponents(string: req.application.hostName)!
        lastLinkComponents.path = "/api/admin/contacts"
        
        let lastOffset = count - (count % limit)
        
        lastLinkComponents.queryItems = [
            URLQueryItem(name: "page[offset]", value: String(lastOffset)),
            URLQueryItem(name: "page[limit]", value: String(limit))
        ]
        let lastLink = lastLinkComponents.url!

        let nextLink : URL? = {
            if (offset + limit < count) {
                var nextLinkComponents = URLComponents(string: req.application.hostName)!
                nextLinkComponents.path = "/api/admin/contacts"
                nextLinkComponents.queryItems = [
                    URLQueryItem(name: "page[offset]", value: String(offset + limit)),
                    URLQueryItem(name: "page[limit]", value: String(limit))
                ]
                return nextLinkComponents.url
            } else {
                return nil
            }
        }()
        let prevLink : URL? = {
            if (offset - limit >= 0) {
                var prevLinkComponents = URLComponents(string: req.application.hostName)!
                prevLinkComponents.path = "/api/admin/contacts"
                prevLinkComponents.queryItems = [
                    URLQueryItem(name: "page[offset]", value: String(offset - limit)),
                    URLQueryItem(name: "page[limit]", value: String(limit))
                ]
                return prevLinkComponents.url
            } else {
                return nil
            }
        }()

        
        return JSONAPIMultiResponse(
            links: JSONAPILinksResponse(selfLink: selfLink,
                                        first: firstLink,
                                        last: lastLink,
                                        prev: prevLink,
                                        next: nextLink),
            data: data,
            meta: JSONAPIMetaResponse(total: count)
        )
    }
    
    @Sendable func get(req: Request) async throws -> JSONAPISingleResponse<ContactFormDTO> {
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
                                 attributes: ContactFormDTO(model: model))
        
        
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
    
    @Sendable  func update(req: Request) async throws -> JSONAPISingleResponse<ContactFormDTO> {
        guard let id = req.parameters.get("id") else {
            throw Abort(.preconditionFailed)
        }
        guard let uuid = UUID(uuidString: id) else {
            throw Abort(.preconditionFailed)
        }
        
        guard let model = try await ContactFormModel.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updateRequest = try req.content.decode(JSONAPISingleRequest<ContactFormDTO>.self)
        
        updateRequest.data.attributes.updateModel(model: model)
        
        try await model.save(on: req.db)
        
        let data = JSONAPIObject(type: "contact",
                                 id: model.id!,
                                 attributes: ContactFormDTO(model: model))
        
        
        return JSONAPISingleResponse(data: data)
    }

    @Sendable func create(req: Request) async throws -> JSONAPISingleResponse<ContactFormDTO> {
        let model = ContactFormModel()
        
        let createRequest = try req.content.decode(JSONAPISingleRequest<ContactFormDTO>.self)
        
        createRequest.data.attributes.updateModel(model: model)

        try await model.save(on: req.db)
        
        let data = JSONAPIObject(type: "contact",
                                 id: model.id!,
                                 attributes: ContactFormDTO(model: model))
        
        
        return JSONAPISingleResponse(data: data)
    }
    
 }
