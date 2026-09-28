import random

CLOCK = None


def vectors():
    rnd = random.Random(255)
    for a, b, c in ((255, 255, 255), (0, 0, 0), (1, 1, 1), (128, 128, 128), (200, 0, 100)):
        yield "worked examples", {"a": a, "b": b, "c": c}, {"sum": a + b + c}
    for _ in range(4000):
        a, b, c = rnd.getrandbits(8), rnd.getrandbits(8), rnd.getrandbits(8)
        yield "4000 random", {"a": a, "b": b, "c": c}, {"sum": a + b + c}
