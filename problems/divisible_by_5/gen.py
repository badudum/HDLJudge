import random

CLOCK = None


def vectors():
    rnd = random.Random(248)
    for x in range(200):
        yield "small values", {"x": x}, {"d5": int(x % 5 == 0)}
    for x in (65535, 65530, 65534, 0x8000, 0xFFF0):
        yield "large values", {"x": x}, {"d5": int(x % 5 == 0)}
    for _ in range(4000):
        x = rnd.getrandbits(16)
        yield "4000 random", {"x": x}, {"d5": int(x % 5 == 0)}
