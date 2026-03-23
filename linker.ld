ENTRY(kernel_main)

SECTIONS {
	. = 1M;

	.text : {
		KEEP(*(.multiboot))
		*(.text)
	}

	.rodata : { *(.rodata) }
	.data : { *(data) }

	.bss : {
		*(COMMON)
		*(.bss)
	}
}
