import ArgumentParser

struct List: AsyncParsableCommand {
    internal mutating func run() async throws {
        guard let savedGames = JSONStorage().readAllSavedGames() else {
            print("No games saved")
            return
        }

        for game in savedGames {
            print(game.title)
        }
    }
}
