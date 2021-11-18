import Foundation

extension JSONDecoder {
    static var gitHub: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

struct Repo: Decodable, Identifiable {
    let id: Int
    let name: String
    let htmlUrl: URL
    let description: String?
    let createdAt: Date
    let updatedAt: Date
}

struct Org: Decodable, Identifiable {
    let id: Int
    let name: String
    let htmlUrl: URL
    let publicRepos: Int
    let followers: Int
    let following: Int
}
