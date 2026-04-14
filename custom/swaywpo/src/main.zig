const std = @import("std");
const swaywpo = @import("swaywpo");

const Argv1 = enum {
    container_to_workspace,
    focus_workspace,

    pub fn to_string(self: Argv1) []const u8 {
        return switch (self) {
            .container_to_workspace => "move-container-to-workspace",
            .focus_workspace => "workspace",
        };
    }
};

/// Expects to take in argc <= 2
/// `argv[1]` = enum /* not really an enum */ {
///   .ContainerToWorkspace = "move-container-to-workspace"
///   .FocusWorkspace = "workspace"
/// }
/// `argv[2]` = int, which is space for call action to.
///
/// output = `swaypo.sway.get_focused_display()`
/// ^ this is used as a way to create a space name specific
/// special for that output
///
/// workspace_name = argv[2]
///
/// Build a unique workspace name: "<output>-<workspace_name>"
/// e.g. output DP-2, workspace 3 -> "DP-2-3"
///
/// Do said action from `argv[1]`
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const iargs = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, iargs);

    const argv = iargs[1..];

    if (argv.len != 2) {
        std.debug.print("Usage: {s} <container-to-workspace|focus-workspace> <workspace>\n", .{iargs[0]});
        return;
    }

    const output = try swaywpo.sway.get_focused_output(allocator);
    defer allocator.free(output);

    if (std.mem.eql(u8, Argv1.container_to_workspace.to_string(), argv[0])) {
        const str_buf = try std.mem.concat(allocator, u8, &.{
            output,
            "-",
            argv[1],
        });
        defer allocator.free(str_buf);

        try swaywpo.sway.container_to_workspace(str_buf);
        return;
    } else if (std.mem.eql(u8, Argv1.focus_workspace.to_string(), argv[0])) {
        const str_buf = try std.mem.concat(allocator, u8, &.{
            output,
            "-",
            argv[1],
        });
        defer allocator.free(str_buf);

        try swaywpo.sway.focus_workspace(str_buf);
        return;
    } else {
        std.debug.print("{s} is not a valid action.\n", .{argv[0]});
        return;
    }
}
