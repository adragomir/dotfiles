# esp general Makefile - adragomir@gmail.com

BOOT ?= none

# name for the target project
TARGET = app
SDK_FLAVOR = rtos
FLAVOR = debug

# Output directories to store intermediate compiled files
# relative to the project directory
BUILD_BASE = build

# which modules (subdirectories) of the project to include in compiling
MODULES = user_rtos
EXTRA_INCDIR    = include 

###########################################################################
# Base directory for the compiler
XTENSA_TOOLS_ROOT ?= /usr/local/Cellar/xtensa-lx106-elf
XTENSA_TOOLS_BIN ?= $(XTENSA_TOOLS_ROOT)/bin

# base directory of the ESP8266 SDK package, absolute
ifeq ($(ESP8266_SDK_BASE),)
	SDK_BASE ?= /usr/local/Cellar/xtensa-lx106-elf/esp_iot_sdk
else
	SDK_BASE = $(ESP8266_SDK_BASE)
endif
ifeq ($(ESP8266_RTOS_SDK_BASE),)
	RTOS_SDK_BASE ?= /usr/local/Cellar/xtensa-lx106-elf/esp_iot_rtos_sdk
else
	RTOS_SDK_BASE = $(ESP8266_RTOS_SDK_BASE)
endif

ifeq ($(SDK_FLAVOR),rtos)
	SDK_BASE = $(RTOS_SDK_BASE)
endif

#Esptool.py path and port
ESPTOOL ?= $(XTENSA_TOOLS_BIN)/esptool.py
ESPPORT ?= /dev/ttyUSB0

# libraries used in this project, mainly provided by the SDK
ifeq ($(SDK_FLAVOR),)
LIBS = c gcc at hal phy pp net80211 lwip wpa main ssl
else
LIBS =  gcc hal json phy pp net80211 wpa main freertos lwip udhcp ssl
endif

# compiler flags using during compilation of source files
ifeq ($(FLAVOR),debug)
	CFLAGS = -Os -g -O2 -Wpointer-arith -Wundef -Werror -Wl,-EL -fno-inline-functions -nostdlib -mlongcalls -mtext-section-literals  -D__ets__ -DICACHE_FLASH
	CXXFLAGS = $(CFLAGS) -fno-rtti -fno-exceptions
else
	$(error FIXME release)
endif

# linker flags used to generate the main object file
LDFLAGS = -nostdlib -Wl,--no-check-sections -u call_user_start -Wl,-static

# linker script used for the above linkier step
LD_SCRIPT	= eagle.app.v6.ld

# various paths from the SDK used in this project
SDK_LIBDIR = lib 
SDK_LDDIR = ld

ifeq ($(SDK_FLAVOR),)
SDK_INCDIR = include include/json
else
SDK_INCDIR = extra_include include include/freertos include/espressif include/lwip include/lwip/ipv4 include/lwip/ipv6
endif

# select which tools to use as compiler, librarian and linker
CC := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-gcc
CXX := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-g++
AR := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-ar
LD := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-gcc
OBJCOPY := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-objcopy
OBJDUMP := $(XTENSA_TOOLS_BIN)/xtensa-lx106-elf-objdump

####
#### no user configurable options below here
####
SRC_DIR		:= $(MODULES)
BUILD_DIR	:= $(addprefix $(BUILD_BASE)/,$(MODULES))

SDK_LIBDIR	:= $(addprefix $(SDK_BASE)/,$(SDK_LIBDIR))
SDK_INCDIR	:= $(addprefix -I$(SDK_BASE)/,$(SDK_INCDIR))

filter_out_template = \
	$(eval $$2 := $(filter-out %$1,$($2)))

filter_template = \
	$(eval $$2 += $(filter %$1,$($3)))

SRC_C_ALL := $(foreach dir,$(SRC_DIR),$(shell find $(dir) \( -iname "*.c" \)))
SRC_CXX_ALL := $(foreach dir,$(SRC_DIR),$(shell find $(dir) \( -iname "*.cpp" \)))

SRC_C_NO_PROG := $(SRC_C_ALL)
$(foreach prog,$(PROGRAMS),$(eval $(call filter_out_template,$(prog),SRC_C_NO_PROG)))
SRC_C_NO_PROG := $(filter-out %_test.c,$(SRC_C_NO_PROG))

SRC_CXX_NO_PROG := $(SRC_CXX_ALL)
$(foreach prog,$(PROGRAMS),$(eval $(call filter_out_template,$(prog),SRC_CXX_NO_PROG)))
SRC_CXX_NO_PROG := $(filter-out %_test.c,$(SRC_CXX_NO_PROG))

SRC_C_PROG_TEST := $(SRC_C_ALL)
$(foreach file,$(SRC_C_NO_PROG),$(eval $(call filter_out_template,$(file),SRC_C_PROG_TEST)))

SRC_CXX_PROG_TEST := $(SRC_CXX_ALL)
$(foreach file,$(SRC_CXX_NO_PROG),$(eval $(call filter_out_template,$(file),SRC_CXX_PROG_TEST)))

SRC_C_PROG := $(filter-out %_test.c,$(SRC_C_PROG_TEST))
SRC_C_TEST := $(SRC_C_PROG_TEST)
$(foreach prog,$(PROGRAMS),$(eval $(call filter_out_template,$(prog),SRC_C_TEST)))

SRC_CXX_PROG := $(filter-out %_test.c,$(SRC_CXX_PROG_TEST))
SRC_CXX_TEST := $(SRC_CXX_PROG_TEST)
$(foreach prog,$(PROGRAMS),$(eval $(call filter_out_template,$(prog),SRC_CXX_TEST)))

OBJ_C_ALL := $(patsubst %.c,%.o,$(SRC_C_ALL))
OBJ_C_NO_PROG := $(patsubst %.c,%.o,$(SRC_C_NO_PROG))
OBJ_C_PROG := $(patsubst %.c,%.o,$(SRC_C_PROG))
OBJ_C_TEST := $(patsubst %.c,%.o,$(SRC_C_TEST))

OBJ_CXX_ALL := $(patsubst %.cpp,%.o,$(SRC_CXX_ALL))
OBJ_CXX_NO_PROG := $(patsubst %.cpp,%.o,$(SRC_CXX_NO_PROG))
OBJ_CXX_PROG := $(patsubst %.cpp,%.o,$(SRC_CXX_PROG))
OBJ_CXX_TEST := $(patsubst %.cpp,%.o,$(SRC_CXX_TEST))

BUILD_OBJ_ALL := $(addprefix $(BUILD_BASE)/,$(OBJ_C_ALL)) $(addprefix $(BUILD_BASE)/,$(OBJ_CXX_ALL))
BUILD_OBJ_NO_PROG := $(addprefix $(BUILD_BASE)/,$(OBJ_C_NO_PROG)) $(addprefix $(BUILD_BASE)/,$(OBJ_CXX_NO_PROG))
BUILD_OBJ_PROG := $(addprefix $(BUILD_BASE)/,$(OBJ_C_PROG)) $(addprefix $(BUILD_BASE)/,$(OBJ_CXX_PROG))
BUILD_OBJ_TEST := $(addprefix $(BUILD_BASE)/,$(OBJ_C_TEST)) $(addprefix $(BUILD_BASE)/,$(OBJ_CXX_TEST))
BUILD_PROGRAMS := $(addprefix $(BUILD_BASE)/,$(patsubst %.c*,%,$(PROGRAMS)))
BUILD_TESTS := $(addprefix $(BUILD_BASE)/test/,$(patsubst %.c*,%,$(TESTS)))

SRC			:= $(foreach sdir,$(SRC_DIR),$(wildcard $(sdir)/*.c*))
OBJ			:= $(patsubst %.c,$(BUILD_BASE)/%.o,$(SRC)) $(patsubst %.cpp,$(BUILD_BASE)/%.o,$(SRC))
LIBS		:= $(addprefix -l,$(LIBS))
APP_AR		:= $(addprefix $(BUILD_BASE)/,$(TARGET)_app.a)
TARGET_OUT	:= $(addprefix $(BUILD_BASE)/,$(TARGET).out)

LD_SCRIPT	:= $(addprefix -T$(SDK_BASE)/$(SDK_LDDIR)/,$(LD_SCRIPT))

INCDIR		:= $(addprefix -I,$(SRC_DIR))
EXTRA_INCDIR	:= $(addprefix -I,$(EXTRA_INCDIR))
MODULE_INCDIR	:= $(addsuffix /include,$(INCDIR))


V ?= $(VERBOSE)
ifeq ("$(V)","1")
Q :=
vecho := @true
else
Q := @
vecho := @echo
endif

# vpath %.c $(SRC_DIR)
# vpath %.cpp $(SRC_DIR)

define make-repo
	mkdir -p build;\
	for dir in "$(SRC_DIR)";\
	do\
		for innerdir in `find $$dir -type d`;\
		do\
			mkdir -p $(BUILD_BASE)/$$innerdir;\
		done\
	done
endef

define compile-objects
$1/%.o: %.c
	$(vecho) "CC $$<"
	$(Q) $(CC) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CFLAGS)  -c $$< -o $$@
$1/%.o: %.cpp
	$(vecho) "CXX $$<"
	$(Q) $(CXX) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CXXFLAGS)  -c $$< -o $$@
endef

.PHONY: all checkdirs flash flashinit clean printvars buildrepo testecho

all: checkdirs $(TARGET_OUT) 

$(BUILD_BASE)/%.o: %.c | buildrepo
	$(vecho) "CC $<"
	$(Q) $(CC) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CFLAGS)  -c $< -o $@

$(BUILD_BASE)/%.o: %.cpp | buildrepo
	$(vecho) "CXX $<"
	$(Q) $(CXX) $(INCDIR) $(MODULE_INCDIR) $(EXTRA_INCDIR) $(SDK_INCDIR) $(CXXFLAGS)  -c $< -o $@

$(APP_AR): $(BUILD_OBJ_NO_PROG)
	$(vecho) "AR $@"
	$(Q) $(AR) cru $@ $^

$(TARGET_OUT): $(APP_AR)
	$(vecho) "LD $@"
	$(Q) $(LD) -L$(SDK_LIBDIR) $(LD_SCRIPT) $(LDFLAGS) -Wl,--start-group $(LIBS) $(APP_AR) -Wl,--end-group -o $@
	$(Q) $(OBJDUMP) -h $@
	$(vecho) "FW $@"
	$(Q) $(ESPTOOL) elf2image $(TARGET_OUT) 


checkdirs: $(BUILD_DIR) $(FW_BASE)

$(BUILD_DIR):
	$(Q) mkdir -p $@

firmware:
	$(Q) mkdir -p $@

flash: 	$(TARGET_OUT)-0x00000.bin $(TARGET_OUT)-0x40000.bin
	-$(ESPTOOL) --port $(ESPPORT) write_flash 0x00000 $(TARGET_OUT)-0x00000.bin 0x40000 $(TARGET_OUT)-0x40000.bin

flashinit:
	$(vecho) "Flash init data default and blank data."
	-$(ESPTOOL) --port $(ESPPORT) write_flash 0x7c000 $(SDK_BASE)/bin/esp_init_data_default.bin 0x7e000 $(SDK_BASE)/bin/blank.bin

clean:
	$(Q) rm -f $(APP_AR)
	$(Q) rm -f $(TARGET_OUT)
	$(Q) rm -rf $(BUILD_DIR)
	$(Q) rm -rf $(BUILD_BASE)

printvars:
	@$(foreach V,$(sort $(.VARIABLES)), \
		 $(if $(filter-out environment% default automatic, \
		 $(origin $V)),$(warning $V=$($V) ($(value $V)))))

print-%:
				@echo $* = $($*)

testecho:
	@echo $(SDK_BASE)
	@echo $(RTOS_SDK_BASE)

#$(foreach bdir,$(BUILD_DIR),$(eval $(call compile-objects,$(bdir))))
