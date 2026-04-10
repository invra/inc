const std = @import("std");
const print = std.debug.print;

const esc = "\x1b";

const bold = esc ++ "[1m";
const reset = esc ++ "[0m";
const green = esc ++ "[32m";
const cyan = esc ++ "[36m";

pub fn main() !void {
    print("{s}", .{bold});
    print("This device is certified by:\n", .{});
    print("{s}", .{reset});

    print("{s}", .{green});
    print("Abraham Lincoln", .{});
    print("{s}", .{reset});

    print(" - ", .{});

    print("{s}", .{cyan});
    print("16th Prez\n", .{});
    print("{s}", .{reset});
}
