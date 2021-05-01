MEMORY
{
	FLASH ( rx )	: ORIGIN = 0x08000000, LENGTH = 1M
	RAM ( rxw )	: ORIGIN = 0x20000000, LENGTH = 128K
}
__stack_start = ORIGIN(RAM) + LENGTH(RAM);

/*ENTRY(__hard_reset__);*/

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        KEEP(*(.interrupt_vector))
        *(.text)
        *(.text*)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH
}
