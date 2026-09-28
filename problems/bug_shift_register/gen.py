import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(85)
    st = [None] * 4

    def step(name, d):
        nonlocal st
        st = [d] + st[:3]
        known = all(x is not None for x in st)
        taps = sum(x << (8 * i) for i, x in enumerate(st)) if known else None
        return name, {"din": d}, {"taps": taps, "dout": st[3]}

    for d in [0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77]:
        yield step("latency 4", d)
    for d in [0xA0, 0xB0, 0xC0, 0xD0]:
        yield step("taps show every stage", d)
    for _ in range(1000):
        yield step("random stream", rnd.getrandbits(8))
