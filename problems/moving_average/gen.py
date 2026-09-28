import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(29)
    win, dout = [0, 0, 0, 0], 0

    def step(name, din, v=1, rst=0):
        nonlocal win, dout
        if rst:
            win, dout = [0, 0, 0, 0], 0
        elif v:
            win = [din] + win[:3]
            dout = sum(win) // 4
        return name, {"rst": rst, "valid_in": v, "din": din}, {"dout": dout}

    yield step("step response", 0, v=0, rst=1)
    for _ in range(6):
        yield step("step response", 100)
    for d in [7, 200, 13, 99]:
        yield step("holds without valid_in", d, v=0)
    yield step("rounding down", 0, v=0, rst=1)
    for d in [1, 2, 2, 2, 3]:
        yield step("rounding down", d)
    for _ in range(5):
        yield step("full-scale input (no overflow)", 255)
    for _ in range(2000):
        yield step("2000 random samples with gaps", rnd.getrandbits(8), v=int(rnd.random() < 0.7),
                   rst=int(rnd.random() < 0.003))
