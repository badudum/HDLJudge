import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(188)
    regs = [0, 0, 0, 0]

    def step(name, we=0, wa=0, be=0, wd=0, ra=0, rst=0):
        cg = 0
        if we:
            for b in range(4):
                if (be >> b) & 1:
                    cg |= 1 << (4 * wa + b)
        if rst:
            regs[:] = [0, 0, 0, 0]
        elif we:
            for b in range(4):
                if (be >> b) & 1:
                    m = 0xFF << (8 * b)
                    regs[wa] = (regs[wa] & ~m) | (wd & m)
        return name, {"rst": rst, "we": we, "waddr": wa, "wbe": be, "wdata": wd, "raddr": ra}, {"rdata": regs[ra], "cg_en": cg}

    yield step("full writes", rst=1)
    for r in range(4):
        yield step("full writes", 1, r, 0xF, 0x11111111 * (r + 1), r)
    yield step("byte enables", 1, 1, 0b0101, 0xAABBCCDD, 1)
    yield step("byte enables", 1, 1, 0b1000, 0x99000000, 1)
    yield step("byte enables", 1, 1, 0b0000, 0xFFFFFFFF, 1)
    yield step("clock enables", 1, 2, 0xF, 0x12345678, 2)
    yield step("clock enables", 0, 2, 0xF, 0x0, 2)
    yield step("clock enables", 1, 3, 0b0110, 0x0, 0)
    for _ in range(2500):
        yield step("2500 random cycles", rnd.getrandbits(1), rnd.getrandbits(2), rnd.getrandbits(4), rnd.getrandbits(32), rnd.getrandbits(2),
                   rst=int(rnd.random() < 0.003))
