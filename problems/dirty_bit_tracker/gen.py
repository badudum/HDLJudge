import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(61)
    v = d = wb = wbi = 0

    def step(name, op=0, idx=0, rst=0):
        nonlocal v, d, wb, wbi
        if rst:
            v = d = wb = wbi = 0
        else:
            m = 1 << idx
            wb = 0
            if op in (2, 3) and v & m and d & m:
                wb, wbi = 1, idx
            if op == 1:
                v |= m; d |= m
            elif op == 2:
                v |= m; d &= ~m
            elif op == 3:
                v &= ~m; d &= ~m
        return name, {"rst": rst, "op": op, "index": idx}, {"valid": v, "dirty": d & 0xFF, "writeback": wb, "wb_index": wbi}

    yield step("reset", rst=1)
    yield step("write marks dirty", 1, 3)
    yield step("write marks dirty", 1, 5)
    yield step("fill of a dirty line writes back", 2, 3)
    yield step("fill of a dirty line writes back", 0, 0)
    yield step("fill of a dirty line writes back", 3, 5)
    yield step("clean lines are dropped silently", 2, 3)
    yield step("clean lines are dropped silently", 3, 3)
    yield step("clean lines are dropped silently", 2, 7)
    for _ in range(2500):
        yield step("2500 random operations", rnd.getrandbits(2), rnd.getrandbits(3), rst=int(rnd.random() < 0.003))
