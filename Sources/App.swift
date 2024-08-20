import ArgumentParser

@main
struct F95Watcher: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "F95zone game version checker",
        version: "0.1",
        subcommands: [
            Add.self,
            List.self,
            Update.self,
        ]
    )

    mutating func run() async throws {
    }
}
