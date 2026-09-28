import random

CLOCK = None


def s8(v):
    return v - 256 if v >= 128 else v


def e(a, b):
    return {"mn": min(s8(a), s8(b)) & 0xFF, "mx": max(s8(a), s8(b)) & 0xFF}


def vectors():
    rnd = random.Random(247)
    for a in (0, 1, 0x7F, 0x80, 0xFF, 0x40, 0xC0):
        for b in (0, 1, 0x7F, 0x80, 0xFF, 0x40, 0xC0):
            yield "corner cases", {"a": a, "b": b}, e(a, b)
    for _ in range(4000):
        a, b = rnd.getrandbits(8), rnd.getrandbits(8)
        yield "4000 random", {"a": a, "b": b}, e(a, b)
