const std = @import("std");
const Translator = @import("translate_c").Translator;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const wf = b.addWriteFiles();
    const pwd_h = wf.add("pwd.h", "#include <pwd.h>");
    const unistd_h = wf.add("unistd.h", "#include <unistd.h>");

    const translate_c = b.dependency("translate_c", .{});

    const pwd_translator: Translator = .init(translate_c, .{
        //
        .c_source_file = pwd_h,
        .target = target,
        .optimize = optimize,
    });
    const unistd_translator: Translator = .init(translate_c, .{
        //
        .c_source_file = unistd_h,
        .target = target,
        .optimize = optimize,
    });

    const utils_mod = b.addModule("dev", .{
        .root_source_file = b.path("src/utils/root.zig"),
        .target = target,
        .imports = &.{
            //
            .{ .name = "pwd", .module = pwd_translator.mod },
            .{ .name = "unistd", .module = unistd_translator.mod },
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
    run_cmd.addPassthruArgs();

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
