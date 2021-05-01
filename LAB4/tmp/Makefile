PATH := ${PATH}:/opt/xPacks/qemu-arm/2.8.0-12/bin:\
/opt/gcc-arm-9.2-2019.12-x86_64-arm-none-eabi/bin

SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = qemu-system-gnuarmeclipse
BOARD ?= STM32F4-Discovery
MCU=STM32F407VG
TARGET=firmware
CPU_CC=cortex-m4
TCP_ADDR=1234
#################
# CFLAGS
CFLAGS = -O0 -g3 -Wall
##################
# LDFLAGS
LDFLAGS = -Wall --specs=nosys.specs -nostdlib -lgcc  
##################
# PATH
APP_PATH=$(abspath ./)
##################
# add here GNU ASSEMBLY SOURCES .S
GASSRC += print.S
GASSRC += start.S
##################
SOBJS = $(GASSRC:.S=.o)
COBJS = $(patsubst .c,%.o,$(APP_SRC))
.PHONY: all clean
# Path to directories containing application source 
vpath % $(APP_PATH)


#----------------------------------Build--------------------------------
all: $(SOBJS) $(TARGET).elf $(TARGET).bin

#object_files
%.o: %.S
	$(CC) -g -x assembler-with-cpp  $(CFLAGS) -mcpu=$(CPU_CC) -c -o $@ $^
	

#executable_&_linkable_file
$(TARGET).elf: $(SOBJS) 
	$(CC) $^ -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript.ld -o $@

#binary_file
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -F elf32-littlearm $(TARGET).elf $(TARGET).bin

#-----------------------------------QEMU--------------------------------
qemu:
	$(QEMU)  --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).elf --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S
qemu_run:
	$(QEMU)  --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).bin --semihosting-config enable=on,target=native

clean:
	-rm *.o
	-rm *.elf
	-rm *.bin

