import random

CLOCK = None


def e(a, b, c):
    t = a + b + c
    return {"s": t & 0xFFFF, "cout": t >> 16}


def vectors():
    rnd = random.Random(39)
    for a, b, c in [(0xFFFF, 0, 1), (0xFFFF, 1, 0), (0x7FFF, 1, 0), (0xFFFF, 0xFFFF, 1), (0x00FF, 0x0001, 0), (0x5555, 0xAAAA, 1)]:
        yield "carry chains", {"a": a, "b": b, "cin": c}, e(a, b, c)
    for a in range(8):
        for b in range(8):
            yield "small sums", {"a": a, "b": b, "cin": (a + b) & 1}, e(a, b, (a + b) & 1)
    for i in range(16):
        a = (1 << i) - 1
        yield "carry stops at every position", {"a": a, "b": 1, "cin": 0}, e(a, 1, 0)
    for _ in range(4000):
        a, b, c = rnd.getrandbits(16), rnd.getrandbits(16), rnd.getrandbits(1)
        yield "random operands", {"a": a, "b": b, "cin": c}, e(a, b, c)
