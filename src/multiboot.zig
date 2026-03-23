const MAGIC: u32 = 0xE85250D6;
const ARCH: u32 = 0;
const HEADER_LENGTH: u32 = 16;
const CHECKSUM: u32 = @truncate(0x100000000 - @as(u64, MAGIC + ARCH + HEADER_LENGTH));

pub export const header align(8) linksection(".multiboot") = [4]u32{
    MAGIC,
    ARCH,
    HEADER_LENGTH,
    CHECKSUM,
};
