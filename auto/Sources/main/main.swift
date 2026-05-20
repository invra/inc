import Foundation
import FoundationNetworking

let url = URL(string: "https://ziglang.org/download/\(Downloader.version)/\(Downloader.filename)")!
let destination = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent(Downloader.filename)

print("Downloading Zig \(Downloader.version) to \(destination.path)")

let sema = DispatchSemaphore(value: 0)
let delegate = DownloadDelegate(destination: destination, sema: sema)
let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
session.downloadTask(with: url).resume()
sema.wait()

print("Extracting \(Downloader.filename)...")

let tar = Process()
tar.executableURL = URL(fileURLWithPath: "/usr/bin/env")
tar.arguments = ["tar", "-xf", destination.path, "-C", FileManager.default.currentDirectoryPath]

do {
    try tar.run()
    tar.waitUntilExit()

    if tar.terminationStatus == 0 {
        print("Extracted successfully.")
    } else {
        print("tar failed with exit code \(tar.terminationStatus)")
    }
} catch {
    print("Failed to run tar: \(error.localizedDescription)")
}

let extractedFolder = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent(Downloader.filename.replacingOccurrences(of: ".tar.xz", with: ""))

let gitignore = extractedFolder.appendingPathComponent(".gitignore")

do {
    try "*\n".write(to: gitignore, atomically: true, encoding: .utf8)
} catch {
    print("Failed to write .gitignore: \(error.localizedDescription)")
}

try? FileManager.default.removeItem(at: destination)
