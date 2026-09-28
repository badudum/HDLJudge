import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(76)
    w = [0] * 12

    def step(name, d, rst=0):
        nonlocal w
        w = [0] * 12 if rst else [d] + w[:11]
        c = sum(w)
        return name, {"rst": rst, "din": d}, {"count": c, "alarm": int(c >= 8)}

    yield step("filling the window", 0, rst=1)
    for _ in range(14):
        yield step("filling the window", 1)
    for _ in range(14):
        yield step("sliding out", 0)
    for d in [1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1]:
        yield step("threshold at 8 of 12", d)
    for _ in range(2000):
        yield step("2000 random samples", int(rnd.random() < rnd.choice([0.3, 0.6, 0.8])), rst=int(rnd.random() < 0.003))
