import random

CLOCK = None


def e(d):
    return {"p": bin(d).count("1") & 1}


def vectors():
    rnd = random.Random(37)
    for i in range(64):
        yield "single bits", {"d": 1 << i}, e(1 << i)
    yield "all ones", {"d": (1 << 64) - 1}, e((1 << 64) - 1)
    yield "all ones", {"d": 0}, e(0)
    for _ in range(2000):
        v = rnd.getrandbits(64)
        yield "random words", {"d": v}, e(v)
