import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(165)
    g = 0

    def step(name, req=0, lock=0, rst=0):
        nonlocal g
        if rst:
            g = 0
        else:
            o = g.bit_length() - 1
            if g and (req >> o) & 1 and (lock >> o) & 1:
                pass
            else:
                g = (req & -req) if req else 0
        o = g.bit_length() - 1 if g else 0
        return name, {"rst": rst, "req": req, "lock": lock}, {"gnt": g, "owner": o, "busy": int(g != 0)}

    yield step("fixed priority", rst=1)
    for r in (7, 6, 4, 0):
        yield step("fixed priority", r)
    yield step("lock holds the bus", 4, 4)
    for _ in range(3):
        yield step("lock holds the bus", 5, 4)
    yield step("release", 5, 0)
    yield step("release", 1, 1)
    yield step("lock without request is ignored", 2, 1)
    for _ in range(2500):
        yield step("2500 random cycles", rnd.getrandbits(3), rnd.getrandbits(3) if rnd.random() < 0.5 else 0, rst=int(rnd.random() < 0.003))
