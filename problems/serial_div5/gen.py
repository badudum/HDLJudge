import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(253)
    st = {"r": 0}

    def step(name, v=0, b=0, rst=0):
        if rst:
            st["r"] = 0
        elif v:
            st["r"] = (2 * st["r"] + b) % 5
        return name, {"rst": rst, "valid": v, "bit_in": b}, {"d5": int(st["r"] == 0)}

    yield step("worked examples", rst=1)
    for b in (1, 0, 1, 0):
        yield step("worked examples", 1, b)
    yield step("worked examples", rst=1)
    for b in (1, 1, 0, 0, 1):                 # 25
        yield step("worked examples", 1, b)
    for _ in range(3000):
        yield step("long numbers", int(rnd.random() < 0.8), rnd.getrandbits(1), rst=int(rnd.random() < 0.01))
