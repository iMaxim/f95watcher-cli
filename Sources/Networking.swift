import AsyncHTTPClient
import FoundationEssentials

struct Networking {
    static func getPageBodyFrom(_ url: URL) async throws -> String {
        let request = HTTPClientRequest(url: url.absoluteString)
        let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        let bodyBuffer = try await response.body.collect(upTo: 1024 * 1024)
        let body = String(buffer: bodyBuffer)

        return body
    }
}
