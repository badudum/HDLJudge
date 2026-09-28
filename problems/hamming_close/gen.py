import random

CLOCK = None


def e(a, b):
    d = a ^ b
    return {"close": int(d & (d - 1) == 0)}


def vectors():
    rnd = random.Random(258)
    for a, b in ((0x00F0, 0x00F8), (0x00F0, 0x00F3), (5, 5), (0, 0x8000), (0xFFFF, 0), (0x8000, 0x0001)):
        yield "worked examples", {"a": a, "b": b}, e(a, b)
    for _ in range(3000):
        a = rnd.getrandbits(16)
        k = rnd.choice([0, 1, 1, 2, 3, rnd.randrange(17)])
        b = a
        for i in rnd.sample(range(16), k):
            b ^= 1 << i
        yield "3000 random", {"a": a, "b": b}, e(a, b)
