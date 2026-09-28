import random

CLOCK = None


def e(x):
    return {"p4": int(x != 0 and x & (x - 1) == 0 and (x & 0x5555) != 0)}


def vectors():
    rnd = random.Random(244)
    for i in range(0, 16, 2):
        yield "powers of four", {"x": 1 << i}, e(1 << i)
    for i in range(1, 16, 2):
        yield "other powers of two", {"x": 1 << i}, e(1 << i)
    yield "other values", {"x": 0}, e(0)
    for x in (5, 20, 0x5555, 0xFFFF, 3):
        yield "other values", {"x": x}, e(x)
    for _ in range(2000):
        x = rnd.getrandbits(16)
        yield "2000 random", {"x": x}, e(x)
