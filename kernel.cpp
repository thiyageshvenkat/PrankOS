extern "C" { // make sure kmain function name isn't changed
    void kmain( unsigned int magic, unsigned int addr) { // catch the two items pushed into stack
        const char *string = "Hello World!";
        char *videoptr = (char*)0xb8000; //video memory
        unsigned int i = 0;
        unsigned int j = 0;
        
        // lclear screen and write blank character
        // supports 25 lines with 80 ascii characters with 2 bytes of memory each
        while(j < 80 * 25 * 2) {
            videoptr[j] = ' '; // blank character
            videoptr[j+1] = 0x02; // attribute-byte (0 - black bg, 2 - green fg)
            j = j+2;
        }
        j = 0;
        // actually writing string
        while(string[j] != '\0') {
            videoptr[i] = string[j];
            videoptr[i+1] = 0x02;
            ++j;
            i = i+2;
        }
        while (1) { /* Infinite Loop */ }
    }
}