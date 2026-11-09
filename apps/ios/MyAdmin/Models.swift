import Foundation

/// 对应 packages/db/src/schema.ts 里的 users 表。改动 schema 时需同步这里。
struct User: Codable, Identifiable, Hashable, Sendable {
    enum Role: String, Codable, Sendable { case user, admin }

    let id: Int
    let email: String
    let name: String
    let role: Role
    let createdAt: Date
}
