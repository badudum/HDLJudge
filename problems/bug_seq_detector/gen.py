import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(84)
    h = []

    def step(name, d, rst=0):
        nonlocal h
        h = [] if rst else (h + [d])[-4:]
        return name, {"rst": rst, "din": d}, {"found": int(h == [1, 1, 0, 1])}

    yield step("single match", 0, rst=1)
    for d in [0, 1, 1, 0, 1, 0, 0]:
        yield step("single match", d)
    for d in [1, 1, 0, 1, 1, 0, 1, 0, 0]:
        yield step("overlapping matches", d)
    for d in [1, 1, 1, 0, 1, 0]:
        yield step("long run of ones before 101", d)
    for _ in range(1000):
        yield step("1000 random bits", rnd.getrandbits(1), rst=int(rnd.random() < 0.005))
