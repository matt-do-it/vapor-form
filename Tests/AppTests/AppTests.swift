@testable import App
import XCTVapor
import Testing

@Suite("App Tests")
struct AppTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        try await configure(app)
        try await test(app)
        try await app.asyncShutdown()
    }
    
    @Test("Test contact API")
    func testContact() async throws {
        try await withApp { app in
            try await app.test(.POST, "api/contact", beforeRequest: { req in
                try req.content.encode(["name": "Matt", "email": "info@test.de", "message": "Test"])
            }, afterResponse: { res async in
                #expect(res.status == .ok)
            })
        }
    }
    
    @Test("Test contact API")
    func testContactSampleData() async throws {
        try await withApp { app in
            for i in stride(from: 0, to: 100, by: 1) {
                try await app.test(.POST, "api/contact", beforeRequest: { req in
                    try req.content.encode(["name": "Matt " + String(i), "email": "info@test.de", "message": "Test"])
                }, afterResponse: { res async in
                    #expect(res.status == .ok)
                })
            }
        }
    }

}
