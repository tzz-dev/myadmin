import Foundation

struct APIClient: Sendable {
    enum APIError: Error { case badStatus(Int), notFound }

    var baseURL: URL = {
        let s = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String
        return URL(string: s ?? "http://localhost:3002")!
    }()

    static let shared = APIClient()

    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        // Drizzle/Hono 输出 ISO8601,带毫秒
        d.dateDecodingStrategy = .custom { decoder in
            let str = try decoder.singleValueContainer().decode(String.self)
            let f = ISO8601DateFormatter()
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = f.date(from: str) { return date }
            f.formatOptions = [.withInternetDateTime]
            if let date = f.date(from: str) { return date }
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "bad date \(str)"))
        }
        return d
    }()

    func get<T: Decodable>(_ path: String, as type: T.Type = T.self) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: baseURL.appending(path: path))
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        if status == 404 { throw APIError.notFound }
        guard (200..<300).contains(status) else { throw APIError.badStatus(status) }
        return try Self.decoder.decode(T.self, from: data)
    }

    func users() async throws -> [User] { try await get("users") }
    func user(id: Int) async throws -> User { try await get("users/\(id)") }
}
