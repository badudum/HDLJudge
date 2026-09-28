import random

CLOCK = None


def vectors():
    rnd = random.Random(256)
    for a, b in ((0x1234, 0x1234), (0x1234, 0x1236), (0, 0xFFFF), (0x8000, 0)):
        yield "worked examples", {"a": a, "b": b}, {"eq": int(a == b), "diff_mask": a ^ b}
    for _ in range(3000):
        a = rnd.getrandbits(16)
        b = a if rnd.random() < 0.3 else a ^ (1 << rnd.randrange(16)) if rnd.random() < 0.5 else rnd.getrandbits(16)
        yield "3000 random", {"a": a, "b": b}, {"eq": int(a == b), "diff_mask": a ^ b}
