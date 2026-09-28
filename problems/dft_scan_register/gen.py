import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(78)
    q = 0

    def step(name, se=0, si=0, d=0, rst=0):
        nonlocal q
        if rst:
            q = 0
        elif se:
            q = ((q << 1) | si) & 0xFF
        else:
            q = d
        return name, {"rst": rst, "d": d, "se": se, "si": si}, {"q": q, "so": q >> 7}

    yield step("functional capture", rst=1)
    for d in (0x3C, 0xFF, 0x81):
        yield step("functional capture", 0, 0, d)
    for b in [1, 0, 1, 1, 0, 0, 1, 0]:
        yield step("scan shift loads a pattern", 1, b, rnd.getrandbits(8))
    for _ in range(8):
        yield step("scan out unloads MSB first", 1, 0, rnd.getrandbits(8))
    for _ in range(1500):
        yield step("1500 random cycles", int(rnd.random() < 0.6), rnd.getrandbits(1), rnd.getrandbits(8), rst=int(rnd.random() < 0.005))
