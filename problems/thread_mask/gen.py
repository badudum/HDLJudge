import random

CLOCK = None


def e(a, c):
    t, n = a & c, a & ~c & 0xFF
    first = (a & -a).bit_length() - 1 if a else 0
    return {"taken": t, "not_taken": n, "divergent": int(t != 0 and n != 0),
            "first_lane": first, "any_active": int(a != 0)}


def vectors():
    rnd = random.Random(49)
    for a, c in [(0xF0, 0xAA), (0x0F, 0x01), (0x81, 0x80), (0xFF, 0x0F)]:
        yield "divergent branch", {"active": a, "cond": c}, e(a, c)
    for a, c in [(0xFF, 0xFF), (0xFF, 0x00), (0x3C, 0x3C), (0x3C, 0xC3), (0x01, 0xFE)]:
        yield "uniform branch", {"active": a, "cond": c}, e(a, c)
    for c in [0x00, 0xFF, 0x5A]:
        yield "empty warp", {"active": 0, "cond": c}, e(0, c)
    for i in range(8):
        a = 0xFF << i & 0xFF
        yield "first active lane at every position", {"active": a, "cond": 0x55}, e(a, 0x55)
    for _ in range(1500):
        a, c = rnd.getrandbits(8), rnd.getrandbits(8)
        yield "1500 random warps", {"active": a, "cond": c}, e(a, c)
