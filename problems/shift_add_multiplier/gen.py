import random

CLOCK = None


def s8(v):
    return v - 256 if v >= 128 else v


def e(a, b):
    return {"p": (s8(a) * s8(b)) & 0xFFFF}


def vectors():
    rnd = random.Random(161)
    for a, b in [(0xFD, 5), (5, 0xFD), (0xFD, 0xFB), (3, 7)]:
        yield "signs", {"a": a, "b": b}, e(a, b)
    for a in (0x00, 0x01, 0x7F, 0x80, 0xFF):
        for b in (0x00, 0x01, 0x7F, 0x80, 0xFF):
            yield "corner cases (0, 1, 127, -128, -1)", {"a": a, "b": b}, e(a, b)
    for _ in range(4000):
        a, b = rnd.getrandbits(8), rnd.getrandbits(8)
        yield "4000 random products", {"a": a, "b": b}, e(a, b)
