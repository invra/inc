const std = @import("std");

/// Defines structure for Passwd file.
const Passwd = struct {
    login_name: []const u8,
    passwd: []const u8,
    uid: u32,
    gid: u32,
    comment: []const u8,
    home: []const u8,
    shell: []const u8,
};

pub fn getUserShell(allocator: std.mem.Allocator) ![]u8 {
    const uid = std.os.linux.getuid();
    const table = try table_passwd(allocator);
    defer {
        for (table) |p| {
            allocator.free(p.login_name);
            allocator.free(p.passwd);
            allocator.free(p.comment);
            allocator.free(p.home);
            allocator.free(p.shell);
        }
        allocator.free(table);
    }
    for (table) |p| {
        if (p.uid == uid) {
            return try allocator.dupe(u8, p.shell);
        }
    }
    return error.UserNotFound;
}

/// Tables out /etc/passwd into array of `Passwd`
pub fn table_passwd(allocator: std.mem.Allocator) ![]Passwd {
    var list: std.ArrayListUnmanaged(Passwd) = .{};
    defer list.deinit(allocator);

    const file = try std.fs.cwd().openFile("/etc/passwd", .{});
    defer file.close();

    var read_buf: [4096]u8 = undefined;
    var file_reader = file.reader(&read_buf);
    const reader = &file_reader.interface;

    var line_buf = std.Io.Writer.Allocating.init(allocator);
    defer line_buf.deinit();

    while (true) {
        _ = reader.streamDelimiter(&line_buf.writer, '\n') catch |err| {
            if (err == error.EndOfStream) {
                if (line_buf.written().len > 0) {
                    const entry = try parsePasswdLine(allocator, line_buf.written());
                    try list.append(allocator, entry);
                }
                break;
            }
            return err;
        };
        reader.toss(1);

        const line = line_buf.written();
        if (line.len > 0) {
            const entry = try parsePasswdLine(allocator, line);
            try list.append(allocator, entry);
        }
        line_buf.clearRetainingCapacity();
    }

    return try list.toOwnedSlice(allocator);
}

/// Parses a line split by ':' and fills out a `Passwd` struct.
fn parsePasswdLine(allocator: std.mem.Allocator, line: []const u8) !Passwd {
    var it = std.mem.splitScalar(u8, line, ':');
    return Passwd{
        .login_name = try allocator.dupe(u8, it.next() orelse return error.InvalidFormat),
        .passwd = try allocator.dupe(u8, it.next() orelse return error.InvalidFormat),
        .uid = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidFormat, 10),
        .gid = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidFormat, 10),
        .comment = try allocator.dupe(u8, it.next() orelse return error.InvalidFormat),
        .home = try allocator.dupe(u8, it.next() orelse return error.InvalidFormat),
        .shell = try allocator.dupe(u8, it.next() orelse return error.InvalidFormat),
    };
}
