const std = @import("std");
const Builder = std.build.Builder;

pub fn addBuildOptions(b: *Builder, mode: anytype, exe: anytype) void {
    exe.linkLibC();
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("Xfixes");
}

pub fn build(b: *Builder) void {
    const fmt = b.addFmt(&[_][]const u8{ "src", "build.zig" });

    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("clipnotify", "src/main.zig");
    exe.setBuildMode(mode);
    addBuildOptions(b, mode, exe);
    exe.install();

    const testt = b.addTest("src/main.zig");
    addBuildOptions(b, mode, testt);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const fmt_step = b.step("fmt", "Format the code");
    fmt_step.dependOn(&fmt.step);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&fmt.step);
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Test the app");
    test_step.dependOn(&fmt.step);
    test_step.dependOn(&testt.step);
}
