const multiboot = @import("multiboot.zig");


export fn kernel_main() noreturn {
    _ = multiboot.header;
    kmain();
}

fn kmain() noreturn {
    while (true) {}
}

