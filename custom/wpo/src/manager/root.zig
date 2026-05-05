pub const sway = @import("./sway.zig");
const lib = @import("lib");
const std = @import("std");
const Io = std.Io;

pub fn get_focused_output(io: Io, allocator: std.mem.Allocator) ![]u8 {
    const stdout = lib.init.stdout_writer(io);
    return try sway.get_focused_output(io, allocator, stdout);
}

pub fn focus_workspace(io: Io, workspace: []const u8) !void {
    const stdout = lib.init.stdout_writer(io);
    const allocator = try lib.init.alloca();
    try sway.focus_workspace(io, allocator, workspace, stdout);
}

pub fn container_to_workspace(io: Io, workspace: []const u8) !void {
    const stdout = lib.init.stdout_writer(io);
    const allocator = try lib.init.alloca();
    try sway.container_to_workspace(io, allocator, workspace, stdout);
}
