import Foundation

/// A cancellable `Operation` responsible for downloading a single image
final class ImageDownloadOperation: Operation, @unchecked Sendable {

    // MARK: Public properties

    let imageURL: URL

    var onCompletion: ((Result<DownloadResult, Error>) -> Void)?

    // MARK: Private properties

    private let semaphore: DispatchSemaphore

    // MARK: Initialisation

    init(
        imageURL: URL,
        semaphore: DispatchSemaphore
    ) {
        self.imageURL = imageURL
        self.semaphore = semaphore
        super.init()

        name = "Download[\(imageURL.lastPathComponent)]"
    }

    // MARK: Operation lifecycle

    override func main() {

        guard !isCancelled else {
            Logger.log(
                "Cancelled before start: \(imageURL.lastPathComponent)",
                level: .warning
            )
            return
        }

        semaphore.wait()

        defer {
            semaphore.signal()
        }

        guard !isCancelled else {
            Logger.log(
                "Cancelled while waiting: \(imageURL.lastPathComponent)",
                level: .warning
            )
            return
        }

        if ImageCache.shared.contains(url: imageURL) {

            Logger.log(
                "Cache hit: \(imageURL.lastPathComponent)",
                level: .success
            )

            let result = DownloadResult(
                url: imageURL,
                localPath: savedFilePath(),
                fileSize: 0
            )

            onCompletion?(.success(result))

            return
        }

        performDownloadWithRetry()
    }

    // MARK: Download logic

    private func performDownloadWithRetry() {

        var currentAttempt = 0

        while currentAttempt < Constants.maxRetryAttempts {

            if isCancelled {
                return
            }

            currentAttempt += 1

            do {

                Logger.log(
                    "Downloading \(imageURL.lastPathComponent) [Attempt \(currentAttempt)]"
                )

                let data = try downloadData()

                try saveImage(data: data)

                ImageCache.shared.save(
                    data: data,
                    for: imageURL
                )

                let result = DownloadResult(
                    url: imageURL,
                    localPath: savedFilePath(),
                    fileSize: data.count
                )

                Logger.log(
                    "Download completed: \(imageURL.lastPathComponent)",
                    level: .success
                )

                onCompletion?(.success(result))

                return

            } catch {

                Logger.log(
                    "Attempt \(currentAttempt) failed: \(error.localizedDescription)",
                    level: .error
                )

                if currentAttempt < Constants.maxRetryAttempts {

                    let delay = pow(
                        2.0,
                        Double(currentAttempt - 1)
                    ) * Constants.retryBaseDelay

                    Logger.log(
                        "Retrying in \(delay)s...",
                        level: .warning
                    )

                    Thread.sleep(forTimeInterval: delay)

                } else {

                    Logger.log(
                        "Download permanently failed: \(imageURL.lastPathComponent)",
                        level: .error
                    )

                    onCompletion?(.failure(error))
                }
            }
        }
    }

    // MARK: Network

    private func downloadData() throws -> Data {

        let data = try Data(contentsOf: imageURL)

        if data.isEmpty {
            throw DownloadError.emptyData
        }

        return data
    }

    // MARK: File saving

    private func saveImage(data: Data) throws {

        let filePath = savedFilePath()

        let saved = FileManager.default.createFile(
            atPath: filePath,
            contents: data
        )

        if !saved {
            throw DownloadError.saveFailed
        }
    }

    private func savedFilePath() -> String {

        let homeDirectory =
            FileManager.default.homeDirectoryForCurrentUser

        let downloadsFolder =
            homeDirectory
                .appendingPathComponent("Downloads")
                .appendingPathComponent("DwonloadedImages")

        try? FileManager.default.createDirectory(
            at: downloadsFolder,
            withIntermediateDirectories: true
        )

        let fileName =
            UUID().uuidString + ".jpg"

        return downloadsFolder
            .appendingPathComponent(fileName)
            .path
    }
}
