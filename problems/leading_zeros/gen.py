import random

CLOCK = None


def e(x):
    return {"n": 16 - x.bit_length()}


def vectors():
    rnd = random.Random(15)
    yield "zero input gives 16", {"x": 0}, e(0)
    for i in range(16):
        yield "powers of two", {"x": 1 << i}, e(1 << i)
    for i in range(16):
        yield "ones below the leading one", {"x": (1 << (i + 1)) - 1}, e((1 << (i + 1)) - 1)
    for _ in range(3000):
        v = rnd.getrandbits(16) >> rnd.randrange(16)
        yield "3000 random values of every magnitude", {"x": v}, e(v)
