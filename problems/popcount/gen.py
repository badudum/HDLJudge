import random

CLOCK = None


def e(x):
    return {"count": bin(x).count("1")}


def vectors():
    rnd = random.Random(13)
    yield "zero", {"x": 0}, e(0)
    yield "all ones", {"x": 0xFFFF}, e(0xFFFF)
    for i in range(16):
        yield "single bits", {"x": 1 << i}, e(1 << i)
    for i in range(16):
        yield "all but one bit", {"x": 0xFFFF ^ (1 << i)}, e(0xFFFF ^ (1 << i))
    for _ in range(3000):
        v = rnd.getrandbits(16)
        yield "3000 random values", {"x": v}, e(v)
