import random

CLOCK = None


def e(x):
    return {"alt": int(x in (0x5555, 0xAAAA))}


def vectors():
    rnd = random.Random(259)
    for x in (0x5555, 0xAAAA, 0x5554, 0x2AAA, 0xD555, 0, 0xFFFF):
        yield "worked examples", {"x": x}, e(x)
    for _ in range(2000):
        x = rnd.choice([0x5555, 0xAAAA]) ^ (1 << rnd.randrange(16)) if rnd.random() < 0.5 else rnd.getrandbits(16)
        yield "2000 random", {"x": x}, e(x)
