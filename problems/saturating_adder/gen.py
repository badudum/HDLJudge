import random

CLOCK = None


def s8(v):
    return v - 256 if v >= 128 else v


def e(a, b):
    r = s8(a) + s8(b)
    if r > 127:
        return {"sum": 127, "ovf": 1}
    if r < -128:
        return {"sum": 0x80, "ovf": 1}
    return {"sum": r & 0xFF, "ovf": 0}


def vectors():
    rnd = random.Random(16)
    for a, b in [(0x64, 0xE2), (0, 0), (1, 0xFF), (0x7F, 0x80), (0x40, 0x3F)]:
        yield "no overflow", {"a": a, "b": b}, e(a, b)
    for a, b in [(0x64, 0x64), (0x7F, 0x01), (0x7F, 0x7F), (0x40, 0x40)]:
        yield "positive overflow", {"a": a, "b": b}, e(a, b)
    for a, b in [(0x9C, 0x9C), (0x80, 0xFF), (0x80, 0x80), (0xC0, 0xBF)]:
        yield "negative overflow", {"a": a, "b": b}, e(a, b)
    for a in [0x00, 0x01, 0x7E, 0x7F, 0x80, 0x81, 0xFE, 0xFF]:
        for b in [0x00, 0x01, 0x7E, 0x7F, 0x80, 0x81, 0xFE, 0xFF]:
            yield "boundary operands (64 pairs)", {"a": a, "b": b}, e(a, b)
    for _ in range(4000):
        a, b = rnd.getrandbits(8), rnd.getrandbits(8)
        yield "4000 random pairs", {"a": a, "b": b}, e(a, b)
