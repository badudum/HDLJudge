import random

CLOCK = "pclk"
RESET = [0, 0xFF, 0, 0xC0DE0001]


def vectors():
    rnd = random.Random(89)
    regs = list(RESET)

    def cyc(name, psel=0, pen=0, pw=0, addr=0, wd=0, rstn=1):
        nonlocal regs
        if not rstn:
            regs = list(RESET)
        elif psel and pen and pw and (addr >> 2) != 3:
            regs[addr >> 2] = wd
        rd = regs[addr >> 2] if (psel and not pw) else 0
        return name, {"presetn": rstn, "psel": psel, "penable": pen, "pwrite": pw, "paddr": addr, "pwdata": wd}, \
            {"prdata": rd, "pready": 1}

    def write(name, addr, wd):
        yield cyc(name, 1, 0, 1, addr, wd)
        yield cyc(name, 1, 1, 1, addr, wd)

    def read(name, addr):
        yield cyc(name, 1, 0, 0, addr, rnd.getrandbits(32))
        yield cyc(name, 1, 1, 0, addr, rnd.getrandbits(32))

    yield cyc("reset values", rstn=0)
    yield cyc("reset values")
    for a in (0, 4, 8, 12):
        yield from read("reset values", a)
    for a, v in [(0, 0x11111111), (4, 0x22222222), (8, 0x12345678)]:
        yield from write("write then read back", a, v)
    for a in (0, 4, 8):
        yield from read("write then read back", a)
    yield from write("read-only ID register", 12, 0xFFFFFFFF)
    yield from read("read-only ID register", 12)
    yield from read("read-only ID register", 0)
    for _ in range(600):
        a = rnd.choice([0, 4, 8, 12])
        if rnd.random() < 0.5:
            yield from write("600 random transfers", a, rnd.getrandbits(32))
        else:
            yield from read("600 random transfers", a)
        if rnd.random() < 0.3:
            yield cyc("600 random transfers")
