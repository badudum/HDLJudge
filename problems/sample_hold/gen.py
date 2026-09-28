import math
import random

CLOCK = "clk"
PARAMS = {"DROOP": "0.98"}
DROOP = 0.98


def vectors():
    rnd = random.Random(31)
    v = 0.0

    def step(name, track, vin):
        nonlocal v
        v = vin if track else v * DROOP
        return name, {"track": track, "vin": vin}, {"vout": v}

    for x in [0.3, 0.7, -0.2, 1.25, 0.0]:
        yield step("track mode follows vin", 1, x)
    yield step("hold with droop", 1, 1.0)
    for _ in range(60):
        yield step("hold with droop", 0, rnd.uniform(-2, 2))
    yield step("re-acquire after holding", 1, 0.5)
    yield step("re-acquire after holding", 1, -0.75)
    for i in range(1500):
        yield step("1500 cycles: sine input, random track/hold", int(rnd.random() < 0.4),
                   math.sin(i * 0.05) + 0.1 * rnd.uniform(-1, 1))
