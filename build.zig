const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zetasend = b.addExecutable(.{
        .name = "zetasend",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "zetasend.zig" },
    });
    b.installArtifact(zetasend);

    const zetareceive = b.addExecutable(.{
        .name = "zetareceive",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "zetareceive.zig" },
    });
    b.installArtifact(zetareceive);
}
