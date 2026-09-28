import random

CLOCK = "clk"


def rotl(x):
    return ((x << 1) | (x >> 7)) & 0xFF


def vectors():
    rnd = random.Random(187)
    v = [0, 0, 0]
    d = [0, 0, 0]

    def step(name, iv=0, idata=0, rst=0):
        if rst:
            v[:] = [0, 0, 0]; d[:] = [0, 0, 0]
        else:
            if v[1]: d[2] = rotl(d[1])
            if v[0]: d[1] = (d[0] + 1) & 0xFF
            if iv: d[0] = idata ^ 0x5A
            v[2], v[1], v[0] = v[1], v[0], iv
        return name, {"rst": rst, "in_valid": iv, "in_data": idata}, {"out_valid": v[2], "out_data": d[2]}

    yield step("results after 3 cycles", rst=1)
    for x in (0x00, 0x11, 0xFF, 0x5A):
        yield step("results after 3 cycles", 1, x)
    for _ in range(3):
        yield step("results after 3 cycles", 0, 0x77)
    for iv, x in ((1, 0x42), (0, 0x99), (0, 0x13), (1, 0x08), (0, 0xEE), (0, 0xEE), (0, 0xEE), (0, 0xEE)):
        yield step("bubbles don't toggle data", iv, x)
    for _ in range(2500):
        yield step("2500 random cycles", int(rnd.random() < 0.5), rnd.getrandbits(8), rst=int(rnd.random() < 0.003))
