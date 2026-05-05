const std = @import("std");
const Io = std.Io;

/// Spawns a new `ArenaAllocator`
pub fn alloca() !std.mem.Allocator {
    // This pattern is more of an anti-pattern, but it's a pain pointing a
    // pointer for a large allocator. As it seems, as of right now there's
    // no bugs from trying to share foreign allocator material. So this is
    // a pattern should be okay for now.
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer _ = arena.deinit();
    return arena.allocator();
}

/// Spawns in a new stdout `Writer` instance via an `Io`
pub fn stdout_writer(io: Io) *Io.Writer {
    var buf: [128]u8 = undefined;
    var file_writer = std.Io.File.stdout().writer(io, &buf);
    return &file_writer.interface;
}
