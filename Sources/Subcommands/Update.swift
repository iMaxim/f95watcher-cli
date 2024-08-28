import ArgumentParser
import AsyncHTTPClient
import FoundationEssentials

struct Update: AsyncParsableCommand {
    internal mutating func run() async throws {
        try await startUpdating()
    }

    internal func startUpdating() async throws {
        guard let savedGames: [Game] = JSONStorage().readAllSavedGames() else {
            print("Can't read db file.")
            return
        }

        var updatedGames = try await withThrowingTaskGroup(of: Game.self) { group -> [Game] in
            for savedGame in savedGames {
                group.addTask {
                    let body = try await Networking().getPageBodyFrom(savedGame.link)
                    let loadedGameMetadata = Parser.parseBody(body)!
                    return Game(
                        link: savedGame.link,
                        title: loadedGameMetadata.title,
                        version: loadedGameMetadata.version,
                        engine: loadedGameMetadata.engine,
                        author: loadedGameMetadata.author
                    )
                }

            }

            var updatedGames: [Game] = []

            for try await value in group {
                updatedGames.append(value)
            }

            return updatedGames
        }
        updatedGames.sort(by: <)

        for (savedGame, updatedGame) in zip(savedGames, updatedGames) {
            print("Comapring \(savedGame.title) and \(updatedGame.title)")
            if savedGame.version != updatedGame.version {
                print(
                    """
                    \(updatedGame.title)
                    \(updatedGame.version) -> \(updatedGame.version)
                    ---------------------------------------
                    """
                )
            }
        }
    }
}
