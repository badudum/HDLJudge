import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(40)
    prev = None

    def step(name, a, b, c, d):
        nonlocal prev
        y = None if prev is None else prev[0] * prev[1] + prev[2] * prev[3]
        prev = (a, b, c, d)
        return name, {"a": a, "b": b, "c": c, "d": d}, {"y": y}

    yield step("latency is exactly 2", 2, 3, 4, 5)
    yield step("latency is exactly 2", 0, 0, 0, 0)
    yield step("latency is exactly 2", 1, 1, 1, 1)
    yield step("latency is exactly 2", 0, 0, 0, 0)
    for _ in range(3):
        yield step("maximum values", 255, 255, 255, 255)
    for _ in range(3000):
        yield step("streaming: new operands every cycle", *[rnd.getrandbits(8) for _ in range(4)])
