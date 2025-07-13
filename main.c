#include <stdio.h>

extern int _write(int fd, const void *buf, size_t count);

static void put_char(char c)
{
    volatile unsigned char * const uart = (unsigned char *)0x10000000U;
    *uart = c;
}

void print_message(const char *s)
{
    while (*s) put_char(*s++);
}

int main(void) {
    print_message("Hello, world!!\n");
    _write(0, "Hello, world!!\n", 27);
    puts("Hello!\n");
    printf("HOGEHOGE\n");
    _write(0, "FUGAFUGA!!\n", 27);
    fflush(stdout);
    while(1);
}
