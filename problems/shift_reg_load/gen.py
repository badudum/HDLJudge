import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(73)
    q = 0

    def step(name, load=0, din=0, shift=0, d=0, si=0, rst=0):
        nonlocal q
        if rst:
            q = 0
        elif load:
            q = din
        elif shift:
            q = ((q << 1) | si) & 0xFF if d == 0 else (si << 7) | (q >> 1)
        so = (q >> 7) & 1 if d == 0 else q & 1
        return name, {"rst": rst, "load": load, "din": din, "shift": shift, "dir": d, "serial_in": si}, {"q": q, "serial_out": so}

    yield step("parallel load", rst=1)
    yield step("parallel load", 1, 0xA5)
    yield step("shift left", 0, 0, 1, 0, 1)
    for _ in range(8):
        yield step("shift left", 0, 0, 1, 0, 0)
    yield step("shift right", 1, 0xA5)
    yield step("shift right", 0, 0, 1, 1, 0)
    for i in range(8):
        yield step("shift right", 0, 0, 1, 1, i & 1)
    yield step("load has priority over shift", 1, 0x3C, 1, 0, 1)
    for d in (0, 1, 0):
        yield step("hold", 0, 0xFF, 0, d, 1)
    for _ in range(1500):
        yield step("1500 random cycles", int(rnd.random() < 0.1), rnd.getrandbits(8), rnd.getrandbits(1), rnd.getrandbits(1),
                   rnd.getrandbits(1), rst=int(rnd.random() < 0.005))
