import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(83)
    d = 0

    def step(name, en=1, rst=0):
        nonlocal d
        if rst:
            d = 0
        elif en:
            d = 0 if d == 9 else d + 1
        return name, {"rst": rst, "en": en}, {"digit": d, "carry": int(d == 9 and en == 1)}

    yield step("counts 0 to 9 and wraps", rst=1)
    for _ in range(12):
        yield step("counts 0 to 9 and wraps")
    for _ in range(6):
        yield step("carry", 1)
    for _ in range(3):
        yield step("carry needs enable", 0)
    for _ in range(1500):
        yield step("1500 random cycles", int(rnd.random() < 0.7), rst=int(rnd.random() < 0.005))
