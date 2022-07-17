# Author: M Pieklo
# Date: 14.12.2020
# Project: STM8_Hallo_World.
# License: Opensource

ccblack = \033[0;30m
ccred = \033[0;31m
ccgreen = \033[0;32m
ccyellow = \033[0;33m
ccblue = \033[0;34m
ccpurple = \033[0;35m
cccyan = \033[0;36m
ccend = \033[0m

$(info --------------------------)
USER := $(shell whoami)
$(info User: $(USER))

DATE := $(shell date +"%d.%m.%Y")
$(info Date: $(DATE))

TIME := $(shell date +"%H:%M:%S")
$(info Time: $(TIME))

CC_PATH := $(shell which sdcc)
$(info CC_PATH: $(CC_PATH))

ifneq ($(shell test -e $(CC_PATH) && echo -n yes),yes)
$(error error: SDCC package '$(CC_PATH)' does not exist!)
else
CC_VERSION := $(shell sdcc -v)
CC := sdcc
#CC2HEX := arm-none-eabi-objcopy
#$(info Compiler version: $(CC_VERSION))
endif
$(info --------------------------)

#VERSION := $(shell git describe --tags)
#$(info Version: $(VERSION))
#COMMIT_ID := $(shell git rev-parse HEAD)
#$(info Commit ID: $(COMMIT_ID))
$(info --------------------------)

OUT_DIR          := out
BIN_DIR          := $(OUT_DIR)/bin
LIB_DIR          := $(OUT_DIR)/lib

CONSTX = -D__SDCC__

CC_FLAGS = \
	-mstm8 \
	--all-callee-saves \
	--debug \
	-V \
	--verbose \
	--stack-auto \
	--fverbose-asm  \
	--float-reent \
	--no-peep \
	-I. \
	-ISTM8S_StdPeriph_Driver/inc/ \
	--Werror \
	--vc \
	--std-c11
	
LD_FLAGS = \
	-mstm8 \
	--out-fmt-ihx \
	--out-fmt-elf 

#MFLAGS = --verbose -V --debug -mstm8 --all-callee-saves --float-reent --stack-auto -I. -ISTM8S_StdPeriph_Driver/inc/

all: make$(OUT_DIR) $(OUT_DIR)/main.ihx

make$(OUT_DIR):	
	@if [ ! -e $(OUT_DIR) ]; then mkdir $(OUT_DIR); fi
	@if [ ! -e $(BIN_DIR) ]; then mkdir $(BIN_DIR); fi

$(OUT_DIR)/main.rel:
	$(CC) -c $(CC_FLAGS) $(CONSTX) main.c -o $(OUT_DIR)/main.rel
	
$(OUT_DIR)/stm8s_gpio.rel:
	$(CC) -c $(CC_FLAGS) $(CONSTX) STM8S_StdPeriph_Driver/src/stm8s_gpio.c -o $(OUT_DIR)/stm8s_gpio.rel
	
$(OUT_DIR)/stm8s_beep.rel:
	$(CC) -c $(CC_FLAGS) $(CONSTX) STM8S_StdPeriph_Driver/src/stm8s_beep.c -o $(OUT_DIR)/stm8s_beep.rel

$(OUT_DIR)/stm8s_it.rel:
	$(CC) -c $(CC_FLAGS) $(CONSTX) stm8s_it.c -o $(OUT_DIR)/stm8s_it.rel
		
$(OUT_DIR)/main.ihx: \
	$(OUT_DIR)/main.rel \
	$(OUT_DIR)/stm8s_gpio.rel \
	$(OUT_DIR)/stm8s_it.rel \
	$(OUT_DIR)/stm8s_beep.rel
		$(CC) $(LD_FLAGS) $^ -o $@
	
#CFLAGS= -mstm8 --out-fmt-elf --all-callee-saves --debug --verbose --stack-auto --fverbose-asm  --float-reent --no-peep

clean:
	rm -rf out
	
load:
	openocd -f /usr/local/share/openocd/scripts/interface/st-link.cfg \
			-f /usr/local/share/openocd/scripts/target/stm8s103.cfg \
			-c"init"\
			-c"reset halt"\
			-c "load_image $(OUT_DIR)/main.ihx"\
			-c "reset"
			-c "reset exit"
			#-d -c"init" -c "program main.ihx veryfi reset exit"
			#-c "reset halt" -c "reset"
	
	.PHONY clean load
