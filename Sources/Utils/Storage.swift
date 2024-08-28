import FoundationEssentials

struct JSONStorage {
    private let dbDirectory: URL
    private let dbFilepath: URL
    private let fm: FileManager

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    private let jsonEncoder: JSONEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return jsonEncoder
    }()

    init() {
        fm = FileManager.default
        dbDirectory = fm.homeDirectoryForCurrentUser.appending(path: ".local/share/f95watcher")
        dbFilepath = dbDirectory.appending(path: "db.json")
    }

    public func addGame(_ game: Game) throws {
        guard fm.fileExists(atPath: dbFilepath.relativePath) else {
            try fm.createDirectory(at: dbDirectory, withIntermediateDirectories: true)
            let data = try jsonEncoder.encode([game])
            let _ = fm.createFile(atPath: dbFilepath.relativePath, contents: data)
            return
        }

        guard let data = fm.contents(atPath: dbFilepath.relativePath) else {
            return
        }

        var games = try jsonDecoder.decode([Game].self, from: data)
        if games.contains(where: { $0.link == game.link }) {
            print("Game already in database")
            return
        }
        games.append(game)
        games.sort(by: <)
        let updatedData = try jsonEncoder.encode(games)
        try updatedData.write(to: dbFilepath, options: .atomic)
    }

    public func readAllSavedGames() -> [Game]? {
        guard fm.fileExists(atPath: dbFilepath.relativePath) else {
            return nil
        }

        guard let data = fm.contents(atPath: dbFilepath.relativePath) else {
            return nil
        }

        return try? jsonDecoder.decode([Game].self, from: data)
    }
}
