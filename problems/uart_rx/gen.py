import random

CLOCK = "clk"
N = 8


class Rx:
    def __init__(self):
        self.idle, self.k, self.sh, self.data = True, 0, 0, 0
        self.valid = self.ferr = 0

    def edge(self, rst, rx):
        self.valid = self.ferr = 0
        if rst:
            self.idle, self.data = True, 0
            return
        if self.idle:
            if rx == 0:
                self.idle, self.k = False, 0
            return
        self.k += 1
        k = self.k
        if k == 4:
            if rx == 1:
                self.idle = True
        elif 12 <= k <= 68 and (k - 12) % 8 == 0:
            self.sh = (self.sh >> 1) | (rx << 7)
        elif k == 76:
            if rx == 1:
                self.data, self.valid = self.sh, 1
            else:
                self.ferr = 1
            self.idle = True


def frame_bits(byte, stop=1, bit_len=N):
    bits = [0] + [(byte >> i) & 1 for i in range(8)] + [stop]
    out = []
    for b in bits:
        out += [b] * bit_len
    return out


def vectors():
    rnd = random.Random(26)
    m = Rx()

    def run(name, levels, rst_first=False):
        for i, lvl in enumerate(levels):
            rst = int(rst_first and i == 0)
            m.edge(rst, lvl)
            yield name, {"rst": rst, "rx": lvl}, {"data": m.data, "valid": m.valid, "frame_err": m.ferr}

    yield from run("reset and idle line", [1] * 12, rst_first=True)
    yield from run("single frame 0xA5", [1] * 5 + frame_bits(0xA5) + [1] * 10)
    yield from run("glitch on the idle line is not a start bit", [1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] + [1] * 80)
    yield from run("framing error (stop bit = 0)", frame_bits(0x3C, stop=0) + [1] * 20)
    yield from run("back-to-back frames", frame_bits(0x01) + frame_bits(0x80) + frame_bits(0xFF) + frame_bits(0x00) + [1] * 12)
    yield from run("clock mismatch: bits 7 and 9 cycles long", frame_bits(0x69, bit_len=7) + [1] * 12 + frame_bits(0x96, bit_len=9) + [1] * 12)
    levels = []
    for _ in range(40):
        levels += [1] * rnd.randrange(0, 20)
        levels += frame_bits(rnd.getrandbits(8), stop=int(rnd.random() > 0.1))
        if rnd.random() < 0.2:
            levels += [1] * 3 + [0] * rnd.randrange(1, 4) + [1] * 3
    yield from run("40 random frames with gaps, glitches and bad stop bits", levels + [1] * 20)
