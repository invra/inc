const std = @import("std");
const Io = std.Io;
pub const sway = @import("./sway.zig");

pub fn get_focused_output(allocator: std.mem.Allocator) ![]u8 {
    return try sway.get_focused_output(allocator);
}

pub fn focus_workspace(workspace: []const u8) !void {
    try sway.focus_workspace(workspace);
}
pub fn container_to_workspace(workspace: []const u8) !void {
    try sway.container_to_workspace(workspace);
}
