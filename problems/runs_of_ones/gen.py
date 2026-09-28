import random

CLOCK = None
M = 0xFFFF


def e(x):
    return {"run3": int((x & (x >> 1) & (x >> 2)) != 0), "alone": x & ~(x << 1) & ~(x >> 1) & M}


def vectors():
    rnd = random.Random(245)
    for x in (0x0070, 0x00A6, 0, 0xFFFF, 0x8001, 0xC003, 0xE000, 0x0007, 0x6DB6):
        yield "worked examples", {"x": x}, e(x)
    for _ in range(3000):
        x = rnd.getrandbits(16) & rnd.getrandbits(16) if rnd.random() < 0.5 else rnd.getrandbits(16)
        yield "3000 random", {"x": x}, e(x)
