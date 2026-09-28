import random

CLOCK = None


def e(x):
    return {"two": int(bin(x).count("1") == 2)}


def vectors():
    rnd = random.Random(243)
    for i in range(16):
        for j in range(i + 1, 16):
            x = (1 << i) | (1 << j)
            yield "two bits", {"x": x}, e(x)
    for x in [0, 0xFFFF, 1, 0x8000, 7, 0x8001 | 0x10]:
        yield "other counts", {"x": x}, e(x)
    for i in range(16):
        yield "other counts", {"x": 1 << i}, e(1 << i)
    for _ in range(3000):
        k = rnd.choice([1, 2, 3, 4, rnd.randrange(17)])
        x = 0
        for b in rnd.sample(range(16), k):
            x |= 1 << b
        yield "3000 random", {"x": x}, e(x)
