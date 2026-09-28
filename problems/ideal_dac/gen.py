import random

CLOCK = "clk"
PARAMS = {"VREF": "2.5"}
VREF = 2.5


def vectors():
    rnd = random.Random(11)
    v = 0.0

    def step(name, code, update=True):
        nonlocal v
        v = code / 256.0 * VREF
        return name, {"code": code}, {"vout": v}

    for c in [0, 1, 2, 64, 128, 200, 254, 255]:
        yield step("code transitions", c)
    for c in range(256):
        yield step("ramp 0 to 255", c)
    for _ in range(500):
        yield step("500 random codes", rnd.getrandbits(8))
