import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(10)
    q = 0

    def step(name, rst=0, load=0, seed=0, en=0):
        nonlocal q
        if rst:
            q = 0x01
        elif load:
            q = seed & 0xFF
        elif en:
            fb = ((q >> 7) ^ (q >> 5) ^ (q >> 4) ^ (q >> 3)) & 1
            q = ((q << 1) | fb) & 0xFF
        return name, {"rst": rst, "load": load, "seed": seed, "en": en}, {"q": q}

    yield step("reset value", rst=1)
    yield step("reset value", rst=0)
    for _ in range(6):
        yield step("first steps from 0x01", en=1)
    for _ in range(3):
        yield step("holds when en = 0")
    yield step("load a seed", load=1, seed=0xA5)
    yield step("load a seed", en=1)
    yield step("load a seed", en=1)
    yield step("load has priority over en", load=1, seed=0x3C, en=1)
    yield step("reset has priority over load", rst=1, load=1, seed=0xFF, en=1)
    for _ in range(260):
        yield step("full period of 255 states", en=1)
    for _ in range(600):
        r = rnd.random()
        yield step("600 random cycles", rst=int(r < 0.02), load=int(0.02 <= r < 0.08),
                   seed=rnd.getrandbits(8), en=int(rnd.random() < 0.8))
