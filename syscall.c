#include <sys/types.h>
#include <sys/stat.h>
#include <stddef.h>
#include <stdint.h>
#include <errno.h>

#define UART0_BASE 0x10000000

extern char _heap_start;
extern char _heap_end;

int _write(int fd, const void *buf, size_t count) {
    const char *c = (const char *)buf;
    for (size_t i = 0; i < count; i++) {
        *(volatile char *)UART0_BASE = c[i];
    }
    return count;
}

int _close(int fd) { return -1; }
int _fstat(int fd, struct stat *st) {
    st->st_mode = S_IFCHR;
    return 0;
}
int _isatty(int fd) { return 1; }
int _lseek(int fd, int offset, int whence) { return -1; }
int _read(int fd, void *buf, size_t count) { return 0; }
static char* current_break = &_heap_start;
void *_sbrk(ptrdiff_t incr) {
    char* previous_break = current_break;
    char* new_break = current_break + incr;

    if (new_break > &_heap_end) {
        _write(1, "No heap memory\n", 16);
        return (void *)-1;
    }

    current_break = new_break;
    return previous_break;
}
