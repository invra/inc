const std = @import("std");
const colored = @import("colored");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var buf: [128]u8 = undefined;
    var file_writer = std.Io.File.stdout().writer(io, &buf);
    const stdout: *std.Io.Writer = &file_writer.interface;

    try colored.print(stdout, "This device is certified by:\n", .{
        .styles = &.{.bold},
    });
    try stdout.flush();

    try colored.print(stdout, "Abraham Lincoln", .{ .color = .{ .ansi = .green } });
    try colored.print(stdout, " - ", .{});
    try colored.print(stdout, "16th. Prez\n", .{ .color = .{ .ansi = .cyan } });
    try stdout.flush();
}
