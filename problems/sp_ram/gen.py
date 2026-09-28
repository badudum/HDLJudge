import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(158)
    mem, rd = {}, None

    def step(name, en=1, we=0, a=0, wd=0):
        nonlocal rd
        if en:
            rd = mem.get(a)
            if we:
                mem[a] = wd
        return name, {"en": en, "we": we, "addr": a, "wdata": wd}, {"rdata": rd}

    yield step("write then read", 1, 1, 10, 0x5A)
    yield step("write then read", 1, 0, 10)
    yield step("read-first on a write", 1, 1, 10, 0x77)
    yield step("read-first on a write", 1, 0, 10)
    for a in range(64):
        yield step("all 64 words", 1, 1, a, (a * 37 + 11) & 0xFF)
    for a in range(64):
        yield step("all 64 words", 1, 0, 63 - a)
    yield step("enable gates everything", 0, 1, 5, 0)
    yield step("enable gates everything", 1, 0, 5)
    for _ in range(2000):
        yield step("2000 random accesses", int(rnd.random() < 0.85), rnd.getrandbits(1), rnd.getrandbits(6), rnd.getrandbits(8))
