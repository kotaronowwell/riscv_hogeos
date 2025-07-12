OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  rom (rx)  : ORIGIN = 0x80000000, LENGTH = 256K
  ram (rw)  : ORIGIN = 0x80040000, LENGTH = 256K
}

SECTIONS
{
  .text : {
    PROVIDE(_text_start = .);
    *(.reset)
    *(.text .text.*)
    PROVIDE(_text_end = .);
  } >rom AT>rom

  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >rom AT>rom

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.data .data.*)
  } >ram AT>rom   /* Load from ROM, run from RAM */

  .sdata : {
    PROVIDE( __global_pointer$ = . + 0x800 );
    *(.sdata .sdata.*)
    PROVIDE(_data_end = .);
  } >ram AT>rom

  .sbss : {
    . = ALIGN(16);
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*)
  } >ram

  .bss : {
    *(.bss .bss.*)
    . = ALIGN(16);
    PROVIDE(_bss_end = .);
  } >ram

  .stack : {
    . = ALIGN(16);
    PROVIDE(_stack_start = .);
    . = . + 4096;
    PROVIDE(_stack_end = .);
  } >ram
}
