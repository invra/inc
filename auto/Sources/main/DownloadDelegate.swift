import Foundation
import FoundationNetworking

class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    let destination: URL
    let sema: DispatchSemaphore

    init(destination: URL, sema: DispatchSemaphore) {
        self.destination = destination
        self.sema = sema
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        let percent = Int(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) * 100)
        let mb = totalBytesWritten / 1_000_000
        let totalMb = totalBytesExpectedToWrite / 1_000_000
        print("\r\(percent)% (\(mb)/\(totalMb) MB)", terminator: "")
        fflush(stdout)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print()
        do {
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: location, to: destination)
            print("Done! Saved to \(destination.path)")
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
        sema.signal()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if let error = error {
            print("\nDownload failed: \(error.localizedDescription)")
            sema.signal()
        }
    }
}
