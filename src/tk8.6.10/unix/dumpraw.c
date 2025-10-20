/* for debugging, by jc@unternet.net */
#include "dumpraw.h"
#include <stdio.h>
void dumpraw(const char *header, unsigned char *buffer, ssize_t bufsize) {
    fprintf(stderr, "%s (0x%p): ", header, buffer);
    for (int i = 0, j = 0; i < bufsize; i++) {
        j = buffer[i];
	if (' ' <= j && j <= '~') fputc(buffer[i], stderr);
        else fprintf(stderr, "\\x%02x", (unsigned char)j);
    }
    fprintf(stderr, "\n");
}


