//! Controller module for Sway.

const std = @import("std");
const lib = @import("./lib.zig");

/// Return the name of the currently focused output as reported by Sway.
/// Caller owns the returned slice — free it with `allocator.free()`.
pub fn get_focused_output(allocator: std.mem.Allocator) ![]u8 {
    const args = [_][]const u8{
        "sh",                                                              "-c",
        "swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name'",
    };
    const result = try lib.proc.exec(allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        std.debug.print("get_focused_output failed (exit={}): {s}\n", .{
            result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }

    const trimmed = std.mem.trimEnd(u8, result.stdout, "\n");
    return allocator.dupe(u8, trimmed);
}

/// Focus a workspace by name.
pub fn focus_workspace(workspace: []const u8) !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();
    const allocator = da.allocator();

    const args = [_][]const u8{ "swaymsg", "workspace", workspace };
    const result = try lib.proc.exec(allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        std.debug.print("focus_workspace '{s}' failed (exit={}): {s}\n", .{
            workspace, result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }
}

/// Move the focused container to a workspace by name.
pub fn container_to_workspace(workspace: []const u8) !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();
    const allocator = da.allocator();

    const args = [_][]const u8{
        "swaymsg", "move", "container", "to", "workspace", workspace,
    };
    const result = try lib.proc.exec(allocator, &args);
    defer result.deinit(allocator);

    if (!result.ok()) {
        std.debug.print("container_to_workspace '{s}' failed (exit={}): {s}\n", .{
            workspace, result.exit_code, result.stderr,
        });
        return error.CommandFailed;
    }
}
