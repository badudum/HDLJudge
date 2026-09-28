import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(91)
    mem = {}
    rd = None

    def step(name, en=1, we=0, a=0, wd=0):
        nonlocal rd
        if en:
            if we:
                mem[a] = wd
                rd = wd
            else:
                rd = mem.get(a)
        return name, {"en": en, "we": we, "addr": a, "wdata": wd}, {"rdata": rd}

    for a in range(16):
        yield step("all 16 words are independent", 1, 1, a, (a * 17 + 3) & 0xFF)
    for a in range(16):
        yield step("all 16 words are independent", 1, 0, a)
    yield step("write-first read during write", 1, 1, 3, 0x5A)
    yield step("write-first read during write", 1, 0, 3)
    yield step("write-first read during write", 1, 1, 12, 0xC3)
    yield step("enable gates reads and writes", 0, 1, 12, 0x00)
    yield step("enable gates reads and writes", 0, 0, 5)
    yield step("enable gates reads and writes", 1, 0, 12)
    for _ in range(2000):
        yield step("2000 random accesses", int(rnd.random() < 0.8), rnd.getrandbits(1), rnd.getrandbits(4), rnd.getrandbits(8))
