import random

CLOCK = "clk"


def nxt(s, d):
    return (((s << 1) & 0xFF) ^ (0x1D if s & 0x80 else 0)) ^ d


def vectors():
    rnd = random.Random(80)
    s = 0xFF

    def step(name, en=0, d=0, g=0, rst=0):
        nonlocal s
        if rst:
            s = 0xFF
        elif en:
            s = nxt(s, d)
        return name, {"rst": rst, "en": en, "din": d, "golden": g}, {"sig": s, "pass": int(s == g)}

    yield step("reset seed", rst=1, g=0xFF)
    yield step("single step", 1, 0x00, 0xE3)
    yield step("hold when disabled", 0, 0x55, 0x00)
    yield step("signature compare", rst=1)
    data = [rnd.getrandbits(8) for _ in range(20)]
    t = 0xFF
    for d in data:
        t = nxt(t, d)
    for i, d in enumerate(data):
        yield step("signature compare", 1, d, t)
    yield step("signature compare", 0, 0, t)
    yield step("signature compare", 0, 0, t ^ 1)
    for _ in range(1500):
        yield step("1500 random cycles", int(rnd.random() < 0.8), rnd.getrandbits(8), rnd.choice([s, rnd.getrandbits(8)]),
                   rst=int(rnd.random() < 0.005))
