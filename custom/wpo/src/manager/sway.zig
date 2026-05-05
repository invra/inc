//! Controller module for Sway.

const std = @import("std");
const Io = std.Io;
const lib = @import("lib");

/// Return the name of the currently focused output as reported by Sway.
/// Caller owns the returned slice — free it with `allocator.free()`.
pub fn get_focused_output(io: Io, allocator: std.mem.Allocator, stdout: *Io.Writer) ![]u8 {
    const args = [_][]const u8{
        "sh",                                                              "-c",
        "swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name'",
    };
    const result = try lib.proc.exec(io, allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        try stdout.print("get_focused_output failed (exit={}): {s}\n", .{
            result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }

    const trimmed = std.mem.trimEnd(u8, result.stdout, "\n");
    return allocator.dupe(u8, trimmed);
}

/// Focus a workspace by name.
pub fn focus_workspace(io: Io, allocator: std.mem.Allocator, workspace: []const u8, stdout: *Io.Writer) !void {
    const args = [_][]const u8{ "swaymsg", "workspace", workspace };
    const result = try lib.proc.exec(io, allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        try stdout.print("focus_workspace '{s}' failed (exit={}): {s}\n", .{
            workspace, result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }
}

/// Move the focused container to a workspace by name.
pub fn container_to_workspace(io: Io, allocator: std.mem.Allocator, workspace: []const u8, stdout: *Io.Writer) !void {
    const args = [_][]const u8{
        "swaymsg", "move", "container", "to", "workspace", workspace,
    };
    const result = try lib.proc.exec(io, allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        try stdout.print("container_to_workspace '{s}' failed (exit={}): {s}\n", .{
            workspace, result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }
}
