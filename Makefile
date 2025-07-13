CROSS=riscv32-unknown-elf
CFLAGS=-march=rv32i -mabi=ilp32 -nostartfiles -Wall -O2
LDFLAGS=-march=rv32i -mabi=ilp32 -nostartfiles -lc -lg -lgcc

SCATTER=riscv-virt.lds

all: kernel.elf kernel.bin

kernel.elf: start.o main.o syscall.o $(SCATTER)
	$(CROSS)-gcc $(LDFLAGS) -T $(SCATTER) -o $@ start.o main.o syscall.o

%.o: %.c
	$(CROSS)-gcc $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CROSS)-gcc $(CFLAGS) -c $< -o $@

kernel.bin: kernel.elf
	$(CROSS)-objcopy -O binary $< $@

clean:
	rm -f *.o *.elf *.bin
