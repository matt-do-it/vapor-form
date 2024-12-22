import Vapor
import Smtp
import GRPC
import Mustache

struct ContactFormAdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let contact = routes.grouped("api", "admin", "contact")
        
        contact.get(use: index)
     }

    @Sendable func index(req: Request) async throws -> JSONAPIMultiResponse<ContactFormRequest> {
        let model = try await ContactFormModel.query(on: req.db)
            .all()
        
        let data = model.map { t in
            JSONAPIObject(type: "contact-form",
                          id: t.id!,
                          attributes: ContactFormRequest(model: t))
        }
        return JSONAPIMultiResponse(data: data)
    }
}
