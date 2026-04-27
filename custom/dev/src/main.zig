const std = @import("std");
const dev = @import("dev");

const EXTRA_ARGS = 4;

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();
    const allocator = da.allocator();

    const iargs = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, iargs);

    const argv = iargs[1..];

    var has_command = false;

    for (argv) |arg| {
        if (std.mem.eql(u8, arg, "--command")) {
            has_command = true;
            break;
        }
    }

    const max_args = argv.len + EXTRA_ARGS;
    var args = try allocator.alloc([]const u8, max_args);

    var j: usize = 0;

    args[j] = "nix";
    j += 1;
    args[j] = "develop";
    j += 1;

    for (argv) |arg| {
        args[j] = arg;
        j += 1;
    }

    var shell: ?[]const u8 = null;

    if (!has_command) {
        args[j] = "--command";
        j += 1;

        shell = try dev.getUserShell(allocator);
        args[j] = shell.?;
        j += 1;
    }

    const final_args = args[0..j];

    const err = std.process.execv(allocator, final_args);
    std.debug.print("exec failed: {}\n", .{err});
    if (shell) |s| allocator.free(s);
    return err;
}
