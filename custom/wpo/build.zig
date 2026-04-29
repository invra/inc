const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("lib", .{
        .root_source_file = b.path("src/lib/root.zig"),
        .target = target,
    });

    const manager_mod = b.addModule("manager", .{
        .root_source_file = b.path("src/manager/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "lib", .module = lib_mod },
        },
    });

    const exe = b.addExecutable(.{
        .name = "wpo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "manager", .module = manager_mod },
                .{ .name = "lib", .module = lib_mod },
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

    const install_docs = b.addInstallDirectory(.{
        .source_dir = exe.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);

    const manager_mod_tests = b.addTest(.{
        .root_module = manager_mod,
    });
    const lib_mod_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    const run_manager_mod_tests = b.addRunArtifact(manager_mod_tests);
    const run_lib_mod_tests = b.addRunArtifact(lib_mod_tests);
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_manager_mod_tests.step);
    test_step.dependOn(&run_lib_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
