const std = @import("std");
const c = @cImport({
    @cInclude("pwd.h");
    @cInclude("unistd.h");
});

pub fn getUserShell(allocator: std.mem.Allocator) ![]u8 {
    const fallback = "/usr/bin/sh";

    var pw: c.struct_passwd = undefined;
    var result: ?*c.struct_passwd = null;
    var buf: [4096]u8 = undefined;

    if (c.getpwuid_r(c.getuid(), &pw, &buf, buf.len, &result) != 0 or result == null or pw.pw_shell == null or pw.pw_shell[0] == 0) {
        return allocator.dupe(u8, fallback);
    }

    const shell = std.mem.span(pw.pw_shell);
    if (shell.len == 0) return allocator.dupe(u8, fallback);

    return allocator.dupe(u8, shell);
}
