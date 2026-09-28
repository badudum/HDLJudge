import random

CLOCK = None


def s8(v):
    return v - 256 if v >= 128 else v


def e(a, b):
    x, y = s8(a), s8(b)
    return {"r": 3 if x < y else (1 if x > y else 0)}


def vectors():
    rnd = random.Random(262)
    for a in (0, 1, 0x7F, 0x80, 0xFF):
        for b in (0, 1, 0x7F, 0x80, 0xFF):
            yield "corner cases", {"a": a, "b": b}, e(a, b)
    for _ in range(3000):
        a = rnd.getrandbits(8)
        b = a if rnd.random() < 0.2 else rnd.getrandbits(8)
        yield "3000 random", {"a": a, "b": b}, e(a, b)
