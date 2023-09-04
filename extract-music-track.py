#!/usr/bin/python3

from pathlib import Path

ROM = 'finalfight-eu.sfc'
TRACK_SRC = 0xa
TRACK_DEST = 0x9

EU_US_OFFSET = 0x800
SPC_OFFSET = 0x3fbeb
TABLE = 0xe02
DIR = 'channels'
FILENAME = 'channel'
NUM_CHANNELS = 8


def read_big_endian_word(rom, offset):
    return rom[offset+1] | (rom[offset] << 8)


def addr_to_offset(addr):
    return SPC_OFFSET + addr


def get_table_addr(rom, track):
    offset = addr_to_offset(TABLE + 2*track)
    return read_big_endian_word(rom, offset)


def fix_pointers(channel, start, end, offset):
    result = bytearray(channel)
    for n, (a, b) in enumerate(zip(channel, channel[1:])):
        word = (a << 8) | b
        if start <= word < end:
            word += offset
            result[n] = word >> 8
            result[n+1] = word & 0xff
    return result


def get_pointers(rom, track):
    table_addr = get_table_addr(rom, track) + 1
    table_end = get_table_addr(rom, track+1)
    pointers = []
    for _ in range(NUM_CHANNELS):
        ptr = read_big_endian_word(rom, addr_to_offset(table_addr))
        pointers.append(ptr)
        table_addr += 2
    return pointers + [table_end]


def extract_track(rom, track_src, track_dest):
    path = Path(DIR)
    path.mkdir(exist_ok=True)
    pointers = get_pointers(rom, track_src)
    dest_offset = EU_US_OFFSET \
            + get_table_addr(rom, track_dest) \
            - get_table_addr(rom, track_src)
    for i in range(NUM_CHANNELS):
        ptr = pointers[i]
        length = pointers[i+1] - ptr
        offset = addr_to_offset(ptr)
        channel = fix_pointers(
                rom[offset:offset+length],
                ptr,
                pointers[i+1],
                dest_offset
                )
        with open(path / f'{FILENAME}_{i:02}.bin', 'wb') as outf:
            outf.write(channel)


def main():
    with open(ROM, 'rb') as inf:
        rom = inf.read()
    extract_track(rom, TRACK_SRC, TRACK_DEST)


if __name__ == '__main__':
    main()
