const std = @import("std");
const dev = @import("utils");

const EXTRA_ARGS = 4;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var buf: [128]u8 = undefined;
    var file_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout: *std.Io.Writer = &file_writer.interface;

    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer _ = arena.deinit();
    const allocator = arena.allocator();

    const iargs = try init.minimal.args.toSlice(init.arena.allocator());
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

    const err = std.process.replace(init.io, .{ .argv = final_args });
    try stdout.print("exec failed: {}\n", .{err});
    if (shell) |s| allocator.free(s);
    return err;
}
