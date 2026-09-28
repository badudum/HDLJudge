import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(63)
    busy, k, done, prod, ops = 0, 0, 0, 0, (0, 0)

    def step(name, start=0, a=0, b=0, rst=0):
        nonlocal busy, k, done, prod, ops
        done = 0
        if rst:
            busy, prod = 0, 0
        elif busy:
            k += 1
            if k == 8:
                busy, done, prod = 0, 1, ops[0] * ops[1]
        elif start:
            busy, k, ops = 1, 0, (a, b)
        return name, {"rst": rst, "start": start, "a": a, "b": b}, {"busy": busy, "done": done, "product": prod}

    def op(name, a, b, extra_start=False):
        yield step(name, 1, a, b)
        for i in range(10):
            yield step(name, int(extra_start and i == 2), rnd.getrandbits(8), rnd.getrandbits(8))

    yield step("reset", rst=1)
    yield step("reset")
    yield from op("single multiplication", 7, 6)
    for a, b in [(255, 255), (0, 200), (200, 0), (1, 255), (128, 2)]:
        yield from op("extremes", a, b)
    yield from op("start ignored while busy", 13, 11, extra_start=True)
    for _ in range(150):
        yield from op("150 random products", rnd.getrandbits(8), rnd.getrandbits(8))
    for _ in range(300):
        yield step("back-to-back and random starts", int(rnd.random() < 0.3), rnd.getrandbits(8), rnd.getrandbits(8))
