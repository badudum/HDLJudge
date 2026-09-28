import random

CLOCK = "clk"


def g(n):
    return n ^ (n >> 1)


def vectors():
    rnd = random.Random(164)
    rb, wr = 0, 0

    def step(name, rd=0, wg=None, rst=0):
        nonlocal rb
        wgv = g(wr) if wg is None else wg
        if rst:
            rb = 0
        elif rd and g(rb) != wgv:
            rb = (rb + 1) & 15
        return name, {"rst": rst, "rd_en": rd, "wr_gray_sync": wgv}, {"rd_gray": g(rb), "rd_addr": rb & 7, "empty": int(g(rb) == wgv)}

    yield step("empty until data arrives", rst=1)
    yield step("empty until data arrives", 1)
    wr = 3
    for _ in range(5):
        yield step("pops follow the write pointer", 1)
    for k in range(40):
        wr = (wr + 1) & 15
        yield step("wrap-around of the 4-bit pointer", 1)
    for _ in range(2000):
        if rnd.random() < 0.4 and ((wr - rb) & 15) < 8:
            wr = (wr + 1) & 15
        yield step("2000 random cycles", int(rnd.random() < 0.6), rst=int(rnd.random() < 0.002))
        if rb == 0 and wr and rnd.random() < 0.0:
            pass
