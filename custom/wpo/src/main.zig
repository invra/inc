//! Expects to take in argc <= 2
//!
//! Refer to the `Argv1` struct to see what actions are available
//!
//! We build a unique workspace name of:
//!   - focused output
//!   - the workspace target
//! which looks like: "<output>-<workspace_target>"
//!
//! Example:
//! focused output (x) = "DP-1"
//! the target workspace (y) = "8"
//! therefore: new workspace name = "x-y" => "DP-1-8"

const std = @import("std");
const wpo = @import("wpo");

const Argv1 = enum {
    /// Move a "container" to a workspace
    move_container_to_workspace,
    /// Move to a workspace
    workspace,
};

pub fn main(init: std.process.Init) !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer _ = arena.deinit();
    const allocator = arena.allocator();
    const iargs = try init.minimal.args.toSlice(init.arena.allocator());
    const argv = iargs[1..];

    const constructed_valid_args: []const []const u8 = comptime blk: {
        const fields = @typeInfo(Argv1).@"enum".fields;
        var result: [fields.len][]const u8 = undefined;
        for (fields, 0..) |field, i| {
            var normalized: []const u8 = "";
            for (field.name) |c| {
                normalized = normalized ++ &[_]u8{if (c == '_') '-' else c};
            }
            result[i] = normalized;
        }
        const final = result;
        break :blk &final;
    };

    if (argv.len != 2) {
        const joined = try std.mem.join(allocator, "|", constructed_valid_args);
        defer allocator.free(joined);
        std.debug.print("Usage: {s} <{s}> <workspace>\n", .{ iargs[0], joined });
        return;
    }

    const output = try wpo.get_focused_output(allocator);
    defer allocator.free(output);

    const str_buf = try std.mem.concat(allocator, u8, &.{ output, "-", argv[1] });
    defer allocator.free(str_buf);

    inline for (constructed_valid_args, 0..) |arg, i| {
        if (std.mem.eql(u8, arg, argv[0])) {
            switch (i) {
                0 => try wpo.container_to_workspace(str_buf),
                1 => try wpo.focus_workspace(str_buf),
                else => unreachable,
            }
            return;
        }
    }

    std.debug.print("{s} is not a valid action.\n", .{argv[0]});
}
