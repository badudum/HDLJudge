import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(72)
    b = 0

    def step(name, en=1, rst=0):
        nonlocal b
        if rst:
            b = 0
        elif en:
            b = (b + 1) & 31
        return name, {"rst": rst, "en": en}, {"gray": b ^ (b >> 1), "bin": b}

    yield step("count sequence", rst=1)
    for _ in range(12):
        yield step("count sequence")
    for _ in range(40):
        yield step("wrap-around after 31")
    for e in [0, 0, 1, 0, 1, 1, 0]:
        yield step("enable", e)
    for _ in range(1000):
        yield step("1000 random cycles", int(rnd.random() < 0.7), rst=int(rnd.random() < 0.005))
