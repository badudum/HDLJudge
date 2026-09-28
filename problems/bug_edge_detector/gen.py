import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(90)
    s = [0, 0, 0]

    def step(name, d, rst=0):
        nonlocal s
        s = [0, 0, 0] if rst else [d, s[0], s[1]]
        return name, {"rst": rst, "din": d}, {"level": s[1], "rise": int(s[1] and not s[2]), "fall": int(s[2] and not s[1])}

    yield step("rising edge", 0, rst=1)
    for d in [0, 1, 1, 1, 1, 1]:
        yield step("rising edge", d)
    for d in [0, 0, 0, 0, 0]:
        yield step("falling edge", d)
    for d in [1, 0, 1, 0, 0, 0]:
        yield step("short pulses", d)
    for _ in range(1500):
        yield step("1500 random samples", rnd.getrandbits(1) if rnd.random() < 0.3 else s[0], rst=int(rnd.random() < 0.003))
