import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(75)
    h = [0, 0]
    p = 0

    def step(name, d, rst=0):
        nonlocal h, p
        if rst:
            h, p = [0, 0], 0
        else:
            p = int(h == [0, 1] and d == 0)
            h = [h[1], d]
        return name, {"rst": rst, "din": d}, {"pulse": p}

    yield step("single pulse", 0, rst=1)
    for d in [0, 0, 1, 0, 0, 0]:
        yield step("single pulse", d)
    for d in [0, 1, 1, 0, 0, 1, 1, 1, 0, 0]:
        yield step("wide pulses are ignored", d)
    for d in [0, 1, 0, 1, 0, 1, 0, 0]:
        yield step("back-to-back pulses", d)
    for _ in range(1500):
        yield step("1500 random bits", rnd.getrandbits(1), rst=int(rnd.random() < 0.005))
