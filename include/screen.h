#ifndef _SCREEN_
#define _SCREEN_

#include <stdint.h>
#include <notcouriersans/font_defs.h>      // This is the font. Believe it or not, it's not courier sans.

// So all our functions have easy access to VBE data
// This info table is constructed by Pure64, and the
// way to see what data is where is on this webpage:
// ctyme.com/intr/rb-0274.htm
typedef struct {
        uint16_t pitch;         // AKA "bytes per scanline", offset 0x10
        uint32_t lfb_addr;      // Linear frame buffer physical address, offset 0x28
        uint8_t  pixel_w;       // Pixel width. Divide bits per pixel (off. 0x19) by 8
        uint16_t height;        // Screen height. Offset 0x14.
        uint16_t width;         // Screen width. Offset 0x12.
        uint8_t  depth;         // Color depth. Size of red mask + blue mask + green mask?
} vbe_info_t;

vbe_info_t *vbe_block; 
uint8_t    *vidmem;

// The offset of a character. The font bitmaps start at ASCII 32, so
// a space would be NotCourierSans_Bitmaps[0]. The difference is 32.
#define CHAR_OFFSET  32
#define CHAR_SIZE    36
#define CURR_FONT    NotCourierSans_Bitmaps             // In case we ever want to change fonts

void init_vid();
void putpixel(uint32_t, uint32_t, uint32_t);
void putchar(char);
void puts(const char*);

#endif