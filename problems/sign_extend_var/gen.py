import random

CLOCK = None


def e(x, n):
    w = n + 1
    v = x & ((1 << w) - 1)
    if v >> n & 1:
        v -= 1 << w
    return {"y": v & 0xFFFF}


def vectors():
    rnd = random.Random(250)
    for x, n in ((0xF0D, 3), (0x1234, 15), (0xFFFF, 0), (0xFFFE, 0), (0x0080, 7), (0x007F, 7), (0xAB80, 7), (0x8000, 15)):
        yield "worked examples", {"x": x, "n": n}, e(x, n)
    for n in range(16):
        for _ in range(250):
            x = rnd.getrandbits(16)
            yield "every width", {"x": x, "n": n}, e(x, n)
