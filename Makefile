ASM=nasm
QEMU=qemu-system-i386

SRC_DIR=src
BUILD_DIR=build

.PHONY: all run clean

all: $(BUILD_DIR)/boot_floppy.img

run: $(BUILD_DIR)/boot_floppy.img
	$(QEMU) -fda $<

$(BUILD_DIR)/boot_floppy.img: $(BUILD_DIR)/stage1.bin
	truncate -s 1440k $@
	dd if=$< of=$@ conv=notrunc

$(BUILD_DIR)/stage1.bin: $(SRC_DIR)/stage1.asm $(BUILD_DIR)
	$(ASM) $< -f bin -o $@

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)/*
