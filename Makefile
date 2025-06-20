ASM=nasm
QEMU=qemu-system-i386

SRC_DIR=src
BUILD_DIR=build

.PHONY: all run clean debug

all: $(BUILD_DIR)/boot_floppy.img

run: $(BUILD_DIR)/boot_floppy.img
	$(QEMU) -fda $<

debug: $(BUILD_DIR)/boot_floppy.img
	$(QEMU) -fda $< -s -S

$(BUILD_DIR)/boot_floppy.img: $(BUILD_DIR)/stage1.bin $(BUILD_DIR)/stage2.bin
	truncate -s 1440k $@
	dd if=$(BUILD_DIR)/stage1.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD_DIR)/stage2.bin of=$@ bs=512 seek=1 conv=notrunc

$(BUILD_DIR)/stage1.bin: $(SRC_DIR)/stage1.asm $(BUILD_DIR)
	$(ASM) $< -f bin -I $(SRC_DIR) -o $@

$(BUILD_DIR)/stage2.bin: $(SRC_DIR)/stage2.asm $(BUILD_DIR)
	$(ASM) $< -f bin -I $(SRC_DIR) -o $@

$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)/*
