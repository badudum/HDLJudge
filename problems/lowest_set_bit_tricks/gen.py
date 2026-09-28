import random

CLOCK = None
M = 0xFFFF


def e(x):
    return {"iso": x & (-x) & M, "clr": x & (x - 1) & M, "tmask": ~x & (x - 1) & M}


def vectors():
    rnd = random.Random(242)
    yield "zero", {"x": 0}, e(0)
    for x in (0x0058, 0x8000, 0x0001, 0xFFFF, 0x0100):
        yield "worked examples", {"x": x}, e(x)
    for _ in range(3000):
        x = rnd.getrandbits(16) << rnd.randrange(16) & M
        yield "3000 random", {"x": x}, e(x)
