lorom

if defined("US")
!SPC_OFFSET = $873f0
else
!SPC_OFFSET = $87403
endif

macro spcorg(addr)
    arch 65816
    org !SPC_OFFSET+<addr>
    arch spc700
    base <addr>
endmacro

macro bigendian(addr)
    db (<addr>)>>8
    db (<addr>)&$ff
endmacro


%spcorg($3454)
%bigendian(channel0)
%bigendian(channel1)
%bigendian(channel2)
%bigendian(channel3)
%bigendian(channel4)
%bigendian(channel5)
%bigendian(channel6)
%bigendian(channel7)

channel0: incbin "channels/channel_00.bin"
channel1: incbin "channels/channel_01.bin"
channel2: incbin "channels/channel_02.bin"
channel3: incbin "channels/channel_03.bin"
channel4: incbin "channels/channel_04.bin"
channel5: incbin "channels/channel_05.bin"
channel6: incbin "channels/channel_06.bin"
channel7: incbin "channels/channel_07.bin"
