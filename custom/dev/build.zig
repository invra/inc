const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wf = b.addWriteFiles();
    const generate_pwd_translate_c_h = wf.add("pwd.h", "#include <pwd.h>");
    const generate_unistd_translate_c_h = wf.add("unistd.h", "#include <unistd.h>");

    const pwd_translate_c = b.addTranslateC(.{ .link_libc = true, .target = target, .optimize = optimize, .root_source_file = generate_pwd_translate_c_h });
    const unistd_translate_c = b.addTranslateC(.{ .link_libc = true, .target = target, .optimize = optimize, .root_source_file = generate_unistd_translate_c_h });

    const utils_mod = b.addModule("dev", .{
        .root_source_file = b.path("src/utils/root.zig"),
        .target = target,
        .imports = &.{
            //
            .{ .name = "pwd", .module = pwd_translate_c.createModule() },
            .{ .name = "unistd", .module = unistd_translate_c.createModule() },
        },
    });

    const exe = b.addExecutable(.{
        .name = "dev",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "utils", .module = utils_mod },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const utils_mod_tests = b.addTest(.{
        .root_module = utils_mod,
    });
    const run_utils_mod_tests = b.addRunArtifact(utils_mod_tests);
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_utils_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
