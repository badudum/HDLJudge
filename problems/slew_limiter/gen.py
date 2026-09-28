import math
import random

CLOCK = "clk"
PARAMS = {"SR": "2.0e7"}
STEP = 2.0e7 * 10.0e-9


def vectors():
    rnd = random.Random(32)
    v = 0.0

    def step(name, vin):
        nonlocal v
        d = vin - v
        v = v + max(-STEP, min(STEP, d))
        return name, {"vin": vin}, {"vout": v}

    for _ in range(7):
        yield step("large step is rate-limited", 1.0)
    for x in [1.05, 1.1, 0.95, 1.0]:
        yield step("small changes pass through", x)
    for _ in range(10):
        yield step("falling step", -0.5)
    for i in range(1500):
        f = 0.01 if i < 700 else 0.2
        yield step("1500 steps: slow sine passes, fast sine is slew-limited", 1.5 * math.sin(i * f))
