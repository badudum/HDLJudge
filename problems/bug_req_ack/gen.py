import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(92)
    ack, dout, stb = 0, 0, 0

    def step(name, req, d, rst=0):
        nonlocal ack, dout, stb
        stb = 0
        if rst:
            ack, dout = 0, 0
        elif not ack:
            if req:
                ack, stb, dout = 1, 1, d
        elif not req:
            ack = 0
        return name, {"rst": rst, "req": req, "data_in": d}, {"ack": ack, "data_out": dout, "strobe": stb}

    yield step("single transfer", 0, 0, rst=1)
    for r in [0, 1, 1, 1, 1, 0, 0, 0]:
        yield step("single transfer", r, 0x42 if r else 0x00)
    for r, d in [(1, 0x10), (1, 0x20), (1, 0x30), (0, 0x40), (0, 0x50)]:
        yield step("data captured on req rise", r, d)
    req = 0
    for _ in range(2000):
        if rnd.random() < 0.25:
            req ^= 1
        yield step("2000 cycles of random transfers", req, rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
