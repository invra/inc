const std = @import("std");
const Io = std.Io;
pub const sway = @import("./sway.zig");

pub fn alloca_init() std.mem.Allocator {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer _ = arena.deinit();
    return arena.allocator();
}

pub fn get_focused_output(allocator: std.mem.Allocator) ![]u8 {
    return try sway.get_focused_output(allocator);
}

pub fn focus_workspace(workspace: []const u8) !void {
    const allocator = alloca_init();
    try sway.focus_workspace(allocator, workspace);
}

pub fn container_to_workspace(workspace: []const u8) !void {
    const allocator = alloca_init();
    try sway.container_to_workspace(allocator, workspace);
}
