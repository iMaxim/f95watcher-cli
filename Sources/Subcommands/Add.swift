import ArgumentParser
import AsyncHTTPClient
import FoundationEssentials

struct Add: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Add game to watched list",
        version: "0.0.1"
    )

    @Argument
    internal var url: String

    internal mutating func run() async throws {
        let baseURL = "https://f95zone.to/threads/"
        guard let gameID = extractIDFrom(url), let gameURL = URL(string: "\(baseURL)\(gameID)")
        else { throw AddCommandError.cantHandleProvidedLink }

        let networking = Networking()
        let body = try await networking.getPageBodyFrom(gameURL)
        guard let gameMetadata = Parser.parseBody(body)
        else { throw AddCommandError.cantExtractGameMetadata }

        let game = Game(
            link: gameURL,
            title: gameMetadata.title,
            version: gameMetadata.version,
            engine: gameMetadata.engine,
            author: gameMetadata.author
        )
        try JSONStorage().addGame(game)
    }

    internal func extractIDFrom(_ url: String) -> Int? {
        let urlComponents = url.split(separator: "/")

        guard urlComponents.count >= 4
        else { return nil }

        let gameIDComponent = urlComponents[3]

        if gameIDComponent.contains(where: { $0 == "." }) {
            guard let gameID = gameIDComponent.split(separator: ".").last
            else { return nil }
            return Int(gameID)
        } else {
            return Int(gameIDComponent)
        }
    }
}

extension Add {
    enum AddCommandError: Error {
        case cantHandleProvidedLink
        case cantExtractGameMetadata
    }
}
