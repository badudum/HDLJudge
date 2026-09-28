import random

CLOCK = None


def e(g):
    b, s = 0, 0
    for i in range(31, -1, -1):
        s ^= (g >> i) & 1
        b |= s << i
    return {"b": b}


def vectors():
    rnd = random.Random(254)
    for g in (0b110, 0, 1, 0x80000000, 0xFFFFFFFF, 0xC0000000):
        yield "worked examples", {"g": g}, e(g)
    for _ in range(3000):
        g = rnd.getrandbits(32)
        yield "3000 random", {"g": g}, e(g)
