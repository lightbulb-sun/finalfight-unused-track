.DELETE_ON_ERROR:

ROM_US = finalfight-us.sfc
ROM_JP = finalfight-jp.sfc
ASM = hack.asm
HACK_US = hack-us.sfc
HACK_JP = hack-jp.sfc
SYM_US = hack-us.sym
SYM_JP = hack-jp.sym

PYTHON = python3
SCRIPT = extract-music-track.py
CHANNEL_DIR = channels
CHANNELS = \
		   $(CHANNEL_DIR)/channel_00.bin \
		   $(CHANNEL_DIR)/channel_01.bin \
		   $(CHANNEL_DIR)/channel_02.bin \
		   $(CHANNEL_DIR)/channel_03.bin \
		   $(CHANNEL_DIR)/channel_04.bin \
		   $(CHANNEL_DIR)/channel_05.bin \
		   $(CHANNEL_DIR)/channel_06.bin \
		   $(CHANNEL_DIR)/channel_07.bin

AS = asar
ASFLAGS = --symbols=wla
ASFLAGS_US = $(ASFLAGS) -DUS=1
ASFLAGS_JP = $(ASFLAGS)

all: $(HACK_US) $(HACK_JP)

$(HACK_US): $(ASM) $(CHANNELS)
	cp $(ROM_US) $(HACK_US)
	$(AS) $(ASFLAGS_US) $(ASM) $(HACK_US)

$(HACK_JP): $(ASM) $(CHANNELS)
	cp $(ROM_JP) $(HACK_JP)
	$(AS) $(ASFLAGS_JP) $(ASM) $(HACK_JP)

$(CHANNELS): $(SCRIPT)
	$(PYTHON) $(SCRIPT)

.PHONY:
clean:
	rm -rf $(HACK_US) $(HACK_JP) $(SYM_US) $(SYM_JP) $(CHANNEL_DIR)
