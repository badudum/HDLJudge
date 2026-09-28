import random

CLOCK = None


def e(a, b, sub):
    bb = (~b & 0xFF) if sub else b
    t = a + bb + sub
    y = t & 0xFF
    ovf = int((a >> 7) == (bb >> 7) and (y >> 7) != (a >> 7))
    return {"y": y, "carry": t >> 8, "ovf": ovf}


def vectors():
    rnd = random.Random(46)
    corners = [0x00, 0x01, 0x7F, 0x80, 0x81, 0xFF, 0x40, 0xC0]
    for a in corners:
        for b in corners:
            yield "add: all corner pairs", {"a": a, "b": b, "sub": 0}, e(a, b, 0)
    for a in corners:
        for b in corners:
            yield "subtract: all corner pairs", {"a": a, "b": b, "sub": 1}, e(a, b, 1)
    for _ in range(3000):
        a, b, s = rnd.getrandbits(8), rnd.getrandbits(8), rnd.getrandbits(1)
        yield "3000 random operations", {"a": a, "b": b, "sub": s}, e(a, b, s)
