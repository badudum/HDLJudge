import random

CLOCK = None


def e(x):
    if x == 0:
        return {"nxt": 0}
    k = bin(x).count("1")
    for y in range(x + 1, 1 << 16):
        if bin(y).count("1") == k:
            return {"nxt": y}
    return {"nxt": 0}


def fast(x):
    if x == 0:
        return {"nxt": 0}
    s = x & -x
    r = x + s
    if r >> 16:
        return {"nxt": 0}
    return {"nxt": r | (((x ^ r) >> 2) // s)}


def vectors():
    rnd = random.Random(249)
    for x in (6, 0x38, 1, 0x7FFF, 0x5555, 0x00F0):
        assert e(x) == fast(x)
        yield "worked examples", {"x": x}, e(x)
    for x in (0x8000, 0xF000, 0xFFFF, 0, 0xC000):
        assert e(x) == fast(x) and e(x)["nxt"] == 0
        yield "no next value", {"x": x}, e(x)
    for _ in range(4000):
        x = rnd.getrandbits(16)
        yield "4000 random", {"x": x}, fast(x)
