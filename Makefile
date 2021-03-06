include config.local

ASM := nasm
QMU := qemu-system-x86_64
GCC := clang
LNK := $(TOOLPREFIX)ld
BKS := bochs

CFL = -c -ffreestanding -Wall -Wextra -Iinclude -Icontrib/cjson -nostdlib -std=c99 \
-fno-stack-protector -mno-red-zone -target x86_64-elf -Wno-int-to-pointer-cast
OUT = out/main.o out/interrupt_asm.o out/system.o out/interrupt.o  \
out/strings.o out/screen.o out/idt.o out/io.o out/vfs.o out/hdd_asm.o \
out/hdd.o out/bmfs.o out/vsprintf.o

# Tools to build
TLS = 

# Directories to search in
VPATH = src:src/asm:src/fs:src/inc:src/linux

all: out pure64 kernel

# Build third-party "contrib" targets
include contrib/pure64/build.make

COLS := $(shell tools/cmp.sh $(ASM) $(GCC) $(LNK) $(QMU))

out:
	@mkdir -p out/

print_spc = \
@for i in {-2..$(COLS)}; do \
	printf " "; \
done

tr:
	@echo "\033[1;32mBuilding bootloader\033[0m"

gn: 
	@echo "\033[1;32mBuilding kernel\033[0m"

pure64: tr out/bmfs_mbr.sys out/pure64.sys out/boot_asm.o

kernel: gn $(OUT) out/kernel.sys out/delta.img

tools/%: tools/%.c
	$(call print_spc)
	@echo "$<\r[\033[1m$(GCC)\033[0m]"
	@$(GCC) $< -std=c99 -O3 -o$@

# So if we change any headers, main.c will get recompiled
out/main.o: src/main.c include/*.h
	$(call print_spc)
	@echo "$<\r[\033[1m$(GCC)\033[0m]"
	@$(GCC) $(CFL) -o$@ $<

out/%_asm.o: %.asm
	$(call print_spc)
	@echo "$<\r[\033[1m$(ASM)\033[0m]"
	@$(ASM) -felf64 -o$@ $<

out/%_f.o: %.f
	$(call print_spc)
	@echo "$<\r[\033[1mg95\033[0m]"
	@$(G95) -c -o $@ $<

out/%.o: %.c 
	$(call print_spc)
	@echo "$<\r[\033[1m$(GCC)\033[0m]"
	@$(GCC) $(CFL) -o$@ $<

out/kernel.sys: $(OUT)
	$(call print_spc)
	@echo "$@\r[\033[1m$(LNK)\033[0m]"
	@$(LNK) -Tlink.ld $^ -o$@

out/delta.img: out/bmfs_mbr.sys out/pure64.sys out/kernel.sys startup.d
	$(call print_spc)
	@echo "$^\r[\033[1mbmfs\033[0m]"
	@$(BMFS) $@ initialize 6M $^ &> /dev/null

clean:
	rm -rf out $(TLS)

qemu: all
	$(call print_spc)
	@echo "out/delta.image\r[\033[1m$(QMU)\033[0m]"
	@$(QMU) -m 265 -smp 2 -hda out/delta.img -name "Delta"

bochs: all
	$(BKS) -q
