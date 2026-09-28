import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(265)
    ctr = [1] * 16

    def step(name, pc=0, upd=0, upc=0, taken=0, rst=0):
        if rst:
            ctr[:] = [1] * 16
        elif upd:
            i = (upc >> 2) & 15
            ctr[i] = min(3, ctr[i] + 1) if taken else max(0, ctr[i] - 1)
        i = (pc >> 2) & 15
        return name, {"rst": rst, "pc": pc, "update": upd, "upd_pc": upc, "taken": taken}, {"pred": ctr[i] >> 1, "ctr": ctr[i]}

    yield step("learns a taken branch", 0x40, rst=1)
    for _ in range(4):
        yield step("learns a taken branch", 0x40, 1, 0x40, 1)
    for t in (0, 1, 0, 0, 0):
        yield step("hysteresis: one mispredict does not flip", 0x40, 1, 0x40, t)
    yield step("aliasing: pc[5:2] indexes the table", 0x80, 1, 0x00, 1)
    yield step("aliasing: pc[5:2] indexes the table", 0x80, 1, 0x40, 1)
    yield step("aliasing: pc[5:2] indexes the table", 0x40)
    loop = [rnd.getrandbits(8) & 0xFC for _ in range(6)]
    for k in range(3000):
        pc = rnd.choice(loop) if rnd.random() < 0.8 else rnd.getrandbits(8)
        upc = rnd.choice(loop)
        taken = int(rnd.random() < (0.85 if loop.index(upc) % 2 == 0 else 0.15))
        yield step("3000 random branches", pc, int(rnd.random() < 0.7), upc, taken, rst=int(rnd.random() < 0.002))
