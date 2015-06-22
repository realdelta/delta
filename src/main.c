#include <screen.h>

#define DELTA_VERSION 10292

int kmain() {
	idt_init();
	init_vid();
	printf("Delta v%d \"Absinthe\"\n\n", DELTA_VERSION);
	printf("System Info:\n    General:\n        CPUS: %dx @ %dmHZ\n", *((uint16_t*)0x5014), *((uint16_t*)0x5010));
	printf("        RAM:  %dMiB\n", *((uint16_t*)0x5020));
	printf("    VESA:\n        Resolution:  %dx%d@%dbpp\n", vbe_block->width, vbe_block->height, vbe_block->depth);
	//puts("Hi\nyou");
	return 0xdea1;
}