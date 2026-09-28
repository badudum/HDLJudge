import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(167)
    q = 0

    def step(name, rst=0):
        nonlocal q
        q = 0 if rst else 1 - q
        return name, {"rst": rst}, {"clk_out": q}

    yield step("toggles every edge", 1)
    for _ in range(12):
        yield step("toggles every edge")
    for _ in range(300):
        yield step("reset at random points", int(rnd.random() < 0.05))
