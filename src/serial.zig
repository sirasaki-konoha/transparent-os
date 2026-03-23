const constants = @import("constants.zig");

pub fn serialWrite(c: u8) void {
    while ((inb(constants.COM1 + 5) & 0x20) == 0) {}
    outb(constants.COM1, c);
}

pub fn outb(port: u16, val: u8) void {
    asm volatile ("outb %[val], %[port]"
        :
        : [val] "{al}" (val),
          [port] "{dx}" (port),
    );
}

pub fn inb(port: u16) u8 {
    return asm volatile ("inb %[port], %[ret]"
        : [ret] "={al}" (-> u8),
        : [port] "{dx}" (port),
    );
}

pub fn print(s: []const u8) void {
    for (s) |c| serialWrite(c);
}

pub fn checkPrintAvailble() bool {
    const result = inb(constants.COM1 + 5);

    if (result == 0x20) {
        return true;
    } else {
        return false;
    }
}

pub fn serialInit() void {
    outb(0x3F8 + 1, 0x00); // 割り込み無効
    outb(0x3F8 + 3, 0x80); // DLAB有効
    outb(0x3F8 + 0, 0x03); // ボーレート 38400
    outb(0x3F8 + 1, 0x00);
    outb(0x3F8 + 3, 0x03); // 8bit, パリティなし, ストップビット1
    outb(0x3F8 + 2, 0xC7); // FIFO有効
    outb(0x3F8 + 4, 0x0B); // RTS/DSR有効
}
