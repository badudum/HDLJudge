import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(163)
    w = [0] * 8

    def step(name, v=0, d=0, rst=0):
        nonlocal w
        if rst:
            w = [0] * 8
        elif v:
            w = [d] + w[:7]
        return name, {"rst": rst, "valid": v, "din": d}, {"wmin": min(w), "wmax": max(w)}

    yield step("fills the window", rst=1)
    for d in (5, 9, 3, 7, 8, 6, 4, 5):
        yield step("fills the window", 1, d)
    for d in (2, 2, 2, 2):
        yield step("maximum leaves the window", 1, d)
    for d in (200, 100):
        yield step("holds without valid", 0, d)
    for _ in range(2500):
        yield step("2500 random samples", int(rnd.random() < 0.8), rnd.getrandbits(8), rst=int(rnd.random() < 0.003))
