import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    @State private var error: String?
    @State private var loading = false

    var body: some View {
        NavigationStack {
            List(users) { user in
                VStack(alignment: .leading, spacing: 2) {
                    Text(user.name).font(.headline)
                    Text(user.email).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            .overlay {
                if loading && users.isEmpty { ProgressView() }
                else if let error { ContentUnavailableView("加载失败", systemImage: "exclamationmark.triangle", description: Text(error)) }
                else if users.isEmpty { ContentUnavailableView("暂无用户", systemImage: "person.2") }
            }
            .navigationTitle("用户")
            .refreshable { await load() }
            .task { await load() }
        }
    }

    private func load() async {
        loading = true
        defer { loading = false }
        do {
            users = try await APIClient.shared.users()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
}

#Preview { UserListView() }
