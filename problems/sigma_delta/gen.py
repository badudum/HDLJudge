import math
import random

CLOCK = "clk"


def q(x):
    # values on a 1/64 grid keep every sum exact in double precision
    return round(x * 64) / 64


def vectors():
    rnd = random.Random(33)
    integ, bit = 0.0, 0

    def step(name, vin, rst=0):
        nonlocal integ, bit
        if rst:
            integ, bit = 0.0, 0
        else:
            fb = 1.0 if bit else -1.0
            integ = integ + vin - fb
            bit = int(integ >= 0.0)
        return name, {"rst": rst, "vin": vin}, {"bit_out": bit}

    yield step("zero input gives 1010...", 0.0, rst=1)
    for _ in range(40):
        yield step("zero input gives 1010...", 0.0)
    for _ in range(200):
        yield step("positive dc input 0.5", 0.5)
    yield step("negative dc input -0.75", 0.0, rst=1)
    for _ in range(200):
        yield step("negative dc input -0.75", -0.75)
    for _ in range(3):
        yield step("reset restarts the integrator", 0.25)
    yield step("reset restarts the integrator", 0.25, rst=1)
    for _ in range(20):
        yield step("reset restarts the integrator", 0.25)
    for i in range(2000):
        yield step("2000-step sine input", q(0.9 * math.sin(2 * math.pi * i / 400)))
    for _ in range(1000):
        yield step("1000 random input levels", q(rnd.uniform(-1, 1)), rst=int(rnd.random() < 0.005))
