import random

CLOCK = None


def vectors():
    rnd = random.Random(261)
    for a, b in ((200, 100), (100, 100), (255, 255), (255, 0), (128, 127), (128, 128), (0, 0)):
        yield "corner cases", {"a": a, "b": b}, {"y": min(a + b, 255)}
    for _ in range(3000):
        a, b = rnd.getrandbits(8), rnd.getrandbits(8)
        yield "3000 random", {"a": a, "b": b}, {"y": min(a + b, 255)}
