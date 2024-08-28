import FoundationEssentials

struct Game: Codable {
    let link: URL
    let title: String
    let version: String
    let engine: String
    let author: String
}

extension Game: Comparable {
    static func < (lhs: Game, rhs: Game) -> Bool {
        lhs.title < rhs.title
    }
}

extension Game: Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.link == rhs.link
    }
}
