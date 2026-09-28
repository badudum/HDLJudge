import random

CLOCK = None


def e(r):
    return {"valid": int(r != 0), "idx": (r & -r).bit_length() - 1 if r else 0}


def vectors():
    rnd = random.Random(236)
    yield "zero", {"req": 0}, e(0)
    for i in range(32):
        yield "single bits", {"req": 1 << i}, e(1 << i)
    for r in (0x80010000, 0xFFFFFFFF, 0x80000000, 0x00018000):
        yield "lowest wins", {"req": r}, e(r)
    for _ in range(3000):
        r = rnd.getrandbits(32) & (0xFFFFFFFF << rnd.randrange(32)) & 0xFFFFFFFF
        yield "3000 random", {"req": r}, e(r)
