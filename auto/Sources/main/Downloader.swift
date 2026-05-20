import Foundation

public struct Downloader {
    public static let version = "0.16.0"

    public static var filename: String {
        #if os(macOS)
            #if arch(arm64)
            return "zig-aarch64-macos-\(version).tar.xz"
            #elseif arch(x86_64)
            return "zig-x86_64-macos-\(version).tar.xz"
            #endif
        #elseif os(Linux)
            #if arch(arm64)
            return "zig-aarch64-linux-\(version).tar.xz"
            #elseif arch(x86_64)
            return "zig-x86_64-linux-\(version).tar.xz"
            #endif
        #endif
    }
}
