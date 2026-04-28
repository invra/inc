const std = @import("std");
const Io = std.Io;

pub const proc = struct {
    pub const Proc = struct {
        /// Timings of proc fork-to-exit in nanoseconds
        elapsed_ns: Io.Duration,
        /// Process identifier code
        pid: std.posix.pid_t,
        /// Feed for stdout (caller must free)
        stdout: []u8 = &[_]u8{},
        /// Feed for stderr (caller must free)
        stderr: []u8 = &[_]u8{},
        /// The POSIX exit-code which was returned
        exit_code: u8,
        /// Force kill knowledge of what signal was given
        term_signal: ?std.posix.SIG,

        /// Free heap-allocated stdout/stderr slices.
        /// Call this when you're done with the Proc.
        pub fn deinit(self: Proc, allocator: std.mem.Allocator) void {
            if (self.stdout.len > 0) allocator.free(self.stdout);
            if (self.stderr.len > 0) allocator.free(self.stderr);
        }

        /// Wrapper to check if a process returned 0 and was not signaled
        pub fn ok(self: Proc) bool {
            return self.exit_code == 0 and self.term_signal == null;
        }

        /// Wrapper to check if a `self.term_signal` was given.
        pub fn signaled(self: Proc) bool {
            return self.term_signal != null;
        }
    };

    /// Execute a command, capturing stdout/stderr.
    /// Returns a `Proc` - the caller can inspect `.stdout`, `.stderr`,
    /// `.exit_code`, `.term_signal`, or just call `.ok()`.
    ///
    /// Example (only care about success):
    ///   try lib.proc.exec(alloc, &args).ok();
    ///
    /// Example (want stdout):
    ///   const result = try lib.proc.exec(alloc, &args);
    ///   defer result.deinit(alloc);
    ///   std.debug.print("{s}\n", .{result.stdout});
    pub fn exec(allocator: std.mem.Allocator, args: []const []const u8) !Proc {
        // Init an Io object inside of here.
        var threaded: Io.Threaded = .init(allocator, .{});
        defer threaded.deinit();
        const io = threaded.io();

        var timer_start = Io.Clock.awake.now(io);

        // Build a child process
        var child = try std.process.spawn(io, .{
            .argv = args,
            .stdout = .pipe,
            .stderr = .pipe,
        });

        const pid = child.id;

        // Read stdout + stderr concurrently via the stdlib helper
        // so we don't deadlock on full pipe buffers
        var stdout_reader = child.stdout.?.reader(io, &.{});
        const stdout_contents = try stdout_reader.interface.allocRemaining(allocator, .limited(10 * 1024 * 1024));

        var stderr_reader = child.stderr.?.reader(io, &.{});
        const stderr_contents = try stderr_reader.interface.allocRemaining(allocator, .limited(10 * 1024 * 1024));

        const term = try child.wait(io);
        const elapsed = timer_start.untilNow(io, .awake);

        const exit_code: u8 = switch (term) {
            .exited => |code| code,
            .signal => 0,
            .stopped => 0,
            .unknown => 0,
        };

        const term_signal: ?std.posix.SIG = switch (term) {
            .signal => |sig| sig,
            else => null,
        };

        return Proc{
            .elapsed_ns = elapsed,
            .pid = pid.?,
            .stdout = stdout_contents,
            .stderr = stderr_contents,
            .exit_code = exit_code,
            .term_signal = term_signal,
        };
    }
};
