import random

CLOCK = "clk"


def upd(c, d):
    for i in range(7, -1, -1):
        fb = ((c >> 7) ^ (d >> i)) & 1
        c = (c << 1) & 0xFF
        if fb:
            c ^= 0x07
    return c


def vectors():
    rnd = random.Random(215)
    st = {"c": 0}

    def step(name, v=0, d=0, init=0, rst=0):
        if rst or init:
            st["c"] = 0
        elif v:
            st["c"] = upd(st["c"], d)
        return name, {"rst": rst, "init": init, "valid": v, "data": d}, {"crc": st["c"]}

    yield step("check value 123456789", rst=1)
    for ch in b"123456789":
        yield step("check value 123456789", 1, ch)
    yield step("init restarts", 0, 0, 1)
    yield step("valid gates updates", 0, 0x55)
    yield step("valid gates updates", 1, 0x55)
    yield step("valid gates updates", 0, 0x12)
    for _ in range(3000):
        yield step("3000 random bytes", int(rnd.random() < 0.8), rnd.getrandbits(8), int(rnd.random() < 0.02), int(rnd.random() < 0.002))
