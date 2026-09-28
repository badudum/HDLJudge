import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(162)
    t = [0, 0, 0]

    def step(name, v=0, d=0, rst=0):
        nonlocal t
        if rst:
            t = [0, 0, 0]
        elif v:
            t = sorted(t + [d], reverse=True)[:3]
        return name, {"rst": rst, "valid": v, "din": d}, {"t0": t[0], "t1": t[1], "t2": t[2]}

    yield step("fills from reset", rst=1)
    for d in (5, 9, 2):
        yield step("fills from reset", 1, d)
    yield step("insert in the middle", 1, 7)
    yield step("duplicates count", 1, 9)
    yield step("small values are dropped", 1, 1)
    yield step("small values are dropped", 0, 255)
    for _ in range(2500):
        yield step("2500 random samples", int(rnd.random() < 0.7), rnd.getrandbits(8), rst=int(rnd.random() < 0.004))
