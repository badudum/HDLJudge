import random

CLOCK = None


def e(x):
    y = 1
    while y < x:
        y <<= 1
    return {"y": y}


def vectors():
    rnd = random.Random(19)
    for i in range(16):
        yield "exact powers of two", {"x": 1 << i}, e(1 << i)
    for i in range(1, 16):
        v = (1 << i) + 1
        yield "between powers", {"x": v}, e(v)
    for i in range(2, 17):
        v = (1 << i) - 1
        yield "between powers", {"x": v}, e(v)
    for v in [0, 1, 2, 3, 32768, 32769, 65535]:
        yield "corner cases (0, 1, 32768, 32769, 65535)", {"x": v}, e(v)
    for _ in range(3000):
        v = rnd.getrandbits(16) >> rnd.randrange(16)
        yield "3000 random values", {"x": v}, e(v)
