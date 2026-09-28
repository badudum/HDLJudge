import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(87)
    v, d = 0, None

    def step(name, iv=0, idata=0, ordy=0, rst=0):
        nonlocal v, d
        if rst:
            v = 0
        else:
            irdy = (not v) or ordy
            if iv and irdy:
                v, d = 1, idata
            elif ordy:
                v = 0
        return name, {"rst": rst, "in_valid": iv, "in_data": idata, "out_ready": ordy}, \
            {"in_ready": int((not v) or ordy), "out_valid": v, "out_data": d if v else None}

    yield step("streaming at full throughput", rst=1)
    for i in range(10):
        yield step("streaming at full throughput", 1, 0x10 + i, 1)
    yield step("backpressure holds the data", 1, 0xAA, 0)
    for i in range(4):
        yield step("backpressure holds the data", 1, 0xB0 + i, 0)
    yield step("backpressure holds the data", 0, 0, 1)
    yield step("backpressure holds the data", 0, 0, 1)
    for _ in range(2500):
        yield step("2500 cycles of random traffic", int(rnd.random() < 0.7), rnd.getrandbits(8), int(rnd.random() < 0.6),
                   rst=int(rnd.random() < 0.003))
