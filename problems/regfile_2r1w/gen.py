import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(52)
    regs = {0: 0}
    r1 = r2 = None

    def step(name, we=0, wa=0, wd=0, ra1=0, ra2=0):
        nonlocal r1, r2
        def rd(a):
            if a == 0:
                return 0
            if we and wa == a:
                return wd
            return regs.get(a)
        r1, r2 = rd(ra1), rd(ra2)
        if we and wa != 0:
            regs[wa] = wd
        return name, {"we": we, "waddr": wa, "wdata": wd, "raddr1": ra1, "raddr2": ra2}, {"rdata1": r1, "rdata2": r2}

    yield step("write then read", 1, 5, 0xCAFEF00D)
    yield step("write then read", 0, 0, 0, 5, 5)
    yield step("write then read", 1, 31, 0x12345678, 5, 0)
    yield step("write then read", 0, 0, 0, 31, 5)
    for i in range(1, 32):
        yield step("fill all 31 registers", 1, i, (i * 0x01010101) ^ 0xA5A5A5A5, i - 1, 0)
    for i in range(32):
        yield step("fill all 31 registers", 0, 0, 0, i, 31 - i)
    yield step("write-first bypass on the same edge", 1, 7, 0x1234, 0, 7)
    yield step("write-first bypass on the same edge", 1, 7, 0x5678, 7, 7)
    yield step("write-first bypass on the same edge", 0, 7, 0x9999, 7, 7)
    yield step("x0 is hardwired to zero", 1, 0, 0xFFFFFFFF, 0, 0)
    yield step("x0 is hardwired to zero", 0, 0, 0, 0, 0)
    for _ in range(3000):
        yield step("3000 random cycles", rnd.getrandbits(1), rnd.getrandbits(5), rnd.getrandbits(32),
                   rnd.getrandbits(5), rnd.getrandbits(5))
