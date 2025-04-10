const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "z",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.addIncludePath(b.path("upstream"));
    lib.installHeadersDirectory(b.path("upstream"), "zlib", .{});

    var flags = try std.BoundedArray([]const u8, 64).init(0);
    try flags.appendSlice(&.{
        "-DHAVE_SYS_TYPES_H",
        "-DHAVE_STDINT_H",
        "-DHAVE_STDDEF_H",
        "-DZ_HAVE_UNISTD_H",
    });
    lib.addCSourceFiles(.{
        .files = srcs,
        .flags = flags.slice(),
    });

    b.installArtifact(lib);
}

const srcs = &.{
    "upstream/adler32.c",
    "upstream/compress.c",
    "upstream/crc32.c",
    "upstream/deflate.c",
    "upstream/gzclose.c",
    "upstream/gzlib.c",
    "upstream/gzread.c",
    "upstream/gzwrite.c",
    "upstream/inflate.c",
    "upstream/infback.c",
    "upstream/inftrees.c",
    "upstream/inffast.c",
    "upstream/trees.c",
    "upstream/uncompr.c",
    "upstream/zutil.c",
};
