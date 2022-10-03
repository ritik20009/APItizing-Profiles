
struct UserDetail: Encodable, Decodable {
    var login: String?
    var name: String?
    var company: String?
    var location: String?
    var public_repos: Int?
    var followers: Int?
    var following: Int?
    var avatar_url: String?
}
