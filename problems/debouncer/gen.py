import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(27)
    out, cnt = 0, 0

    def step(name, btn, rst=0):
        nonlocal out, cnt
        if rst:
            out, cnt = 0, 0
        elif btn != out:
            cnt += 1
            if cnt == 4:
                out, cnt = btn, 0
        else:
            cnt = 0
        return name, {"rst": rst, "btn": btn}, {"clean": out}

    yield step("clean press and release", 0, rst=1)
    for b in [1] * 6 + [0] * 6:
        yield step("clean press and release", b)
    for b in [1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0]:
        yield step("bouncing contact", b)
    for b in [1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0]:
        yield step("short glitches are filtered", b)
    for b in [1, 1, 1, 1, 1]:
        yield step("reset clears the output", b)
    yield step("reset clears the output", 1, rst=1)
    yield step("reset clears the output", 0)
    level = 0
    for _ in range(2000):
        if rnd.random() < 0.02:
            level ^= 1
        b = level ^ int(rnd.random() < 0.15)
        yield step("2000 cycles of a noisy button", b, rst=int(rnd.random() < 0.002))
