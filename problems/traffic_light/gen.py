import random

CLOCK = "clk"
OUT = {"MG": (2, 0), "MY": (1, 0), "SG": (0, 2), "SY": (0, 1)}


def vectors():
    rnd = random.Random(23)
    state, t = "MG", 1

    def step(name, car, rst=0):
        nonlocal state, t
        if rst:
            state, t = "MG", 1
        elif state == "MG" and t >= 6 and car:
            state, t = "MY", 1
        elif state == "MY" and t >= 2:
            state, t = "SG", 1
        elif state == "SG" and t >= 4:
            state, t = "SY", 1
        elif state == "SY" and t >= 2:
            state, t = "MG", 1
        else:
            t = min(t + 1, 100)
        m, s = OUT[state]
        return name, {"rst": rst, "car": car}, {"main": m, "side": s}

    yield step("waits for a car on the side street", 0, rst=1)
    for _ in range(40):
        yield step("waits for a car on the side street", 0)
    yield step("full cycle with a car always waiting", 1, rst=1)
    for _ in range(45):
        yield step("full cycle with a car always waiting", 1)
    yield step("minimum green time is enforced", 0, rst=1)
    for c in [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]:
        yield step("minimum green time is enforced", c)
    for _ in range(4):
        yield step("reset in the middle of a cycle", 1)
    yield step("reset in the middle of a cycle", 1, rst=1)
    for _ in range(10):
        yield step("reset in the middle of a cycle", 0)
    for _ in range(1500):
        yield step("1500 cycles of random traffic", int(rnd.random() < 0.3), rst=int(rnd.random() < 0.003))
