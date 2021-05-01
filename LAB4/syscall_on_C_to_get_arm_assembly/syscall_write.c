#include <sys/syscall.h>
#include <unistd.h>

void main() {

syscall(SYS_write, 1, "SAMPLE\n", 7);

}
