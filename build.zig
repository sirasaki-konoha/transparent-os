const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
        .abi = .none,
    });
    const optimize = b.standardOptimizeOption(.{});
    const kernel = b.addExecutable(.{
        .name = "transparent_kernel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{},
        }),
    });
    kernel.setLinkerScript(b.path("linker.ld"));
    b.installArtifact(kernel);

    const make_isoroot = b.addSystemCommand(&.{
        "sh", "-c",
        "mkdir -p isoroot/boot/grub && cp zig-out/bin/transparent_kernel isoroot/boot/",
    });
    make_isoroot.step.dependOn(b.getInstallStep());

    const make_iso = b.addSystemCommand(&.{
        "grub-mkrescue", "-o", "transparent-os.iso", "isoroot",
    });
    make_iso.step.dependOn(&make_isoroot.step);

    const qemu = b.addSystemCommand(&.{
        "qemu-system-x86_64",
        "-cdrom", "transparent-os.iso",
        "-nographic",
        "-no-reboot",
        "-m", "128M",
    });
    qemu.step.dependOn(&make_iso.step);

    const run_step = b.step("run", "Run kernel in QEMU");
    run_step.dependOn(&qemu.step);
}
