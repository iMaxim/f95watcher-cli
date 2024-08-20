enum Parser {
    struct GameMetadata {
        let author: String
        let engine: String
        let title: String
        let version: String
    }

    static func parseBody(_ input: borrowing String) -> GameMetadata? {
        // TODO: Hack for now
        guard let bookScript = input.slice(from: "\"@type\": \"Book\",", to: "}"),
            let fullTitle = bookScript.slice(from: "\"name\": ", to: ","),
            let version = bookScript.slice(from: "\\nVersion: ", to: "\\n")
        else { return nil }

        let normilizedTitle = fullTitle.replacingOccurrences(of: "&#039;", with: "'")
        let titleSegments = normilizedTitle.split(separator: " - ")
        guard
            let nameVersionDeveloper = titleSegments
                .last?
                .replacingOccurrences(of: "]\"", with: "")
                .split(separator: " [")
        else {
            return nil
        }

        return GameMetadata(
            author: String(nameVersionDeveloper[2]),
            engine: String(titleSegments[1]),
            title: String(nameVersionDeveloper[0]),
            version: version
        )
    }
}
