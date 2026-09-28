import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(79)
    c = 0

    def step(name, en=0, se=0, si=0, rst=0):
        nonlocal c
        if rst:
            c = 0
        elif se:
            c = ((c << 1) | si) & 15
        elif en:
            c = (c + 1) & 15
        return name, {"rst": rst, "en": en, "se": se, "si": si}, {"count": c, "tc": int(c == 15), "so": c >> 3}

    yield step("functional counting", rst=1)
    for _ in range(18):
        yield step("functional counting", 1)
    for b in [1, 1, 1, 0]:
        yield step("scan load, capture, unload", 0, 1, b)
    yield step("scan load, capture, unload", 1, 0, 0)
    for _ in range(4):
        yield step("scan load, capture, unload", 0, 1, 0)
    for b in [1, 0, 1, 0]:
        yield step("scan mode ignores enable", 1, 1, b)
    for _ in range(1500):
        yield step("1500 random cycles", rnd.getrandbits(1), int(rnd.random() < 0.4), rnd.getrandbits(1), rst=int(rnd.random() < 0.005))
