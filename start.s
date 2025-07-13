    .section .reset,"ax",@progbits
    .option norelax
    .globl _start
_start:
    la    gp, __global_pointer$
    la    sp, _stack_end

    # Copy .data section from ROM to RAM
    la    a0, _data_start         # RAM destination
    la    a1, _rodata_start       # ROM source
    la    a2, _data_end           # RAM destination end
1:
    bgeu  a0, a2, 2f
    lw    t0, 0(a1)
    sw    t0, 0(a0)
    addi  a0, a0, 4
    addi  a1, a1, 4
    j     1b
2:
    # Clear .bss section
    la    a0, _bss_start
    la    a1, _bss_end
    li    t0, 0
3:
    bgeu  a0, a1, 4f
    sw    t0, 0(a0)
    addi  a0, a0, 4
    j     3b
4:

    # Call main()
    call main
    j .   # loop forever