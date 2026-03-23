const multiboot = @import("multiboot.zig");
const serial = @import("serial.zig");

export fn kernel_main() noreturn {
    // Zig doesn't load automatically just by importing it, so we need to use it explicitly.
    _ = multiboot.header;

    if (!serial.checkPrintAvailble()) {
        loop();
    }

    serial.print("Hello, from transparent!\n\r");
    kmain();
}

fn kmain() noreturn {
    while (true) {}
}

fn loop() noreturn {
    while (true) {}
}
