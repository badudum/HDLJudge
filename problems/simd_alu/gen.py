import random

CLOCK = None


def lane(x, y, op, w):
    m = (1 << w) - 1
    if op == 0: return (x + y) & m
    if op == 1: return (x - y) & m
    if op == 2: return min(m, x + y)
    return max(x, y)


def e(a, b, mode, op):
    w = 16 if mode else 8
    y = 0
    for i in range(32 // w):
        x, z = (a >> (w * i)) & ((1 << w) - 1), (b >> (w * i)) & ((1 << w) - 1)
        y |= lane(x, z, op, w) << (w * i)
    return {"y": y}


def vectors():
    rnd = random.Random(65)
    names = ["add", "subtract", "saturating add", "max"]
    fixed = {(0, 0): [(0xFF010203, 0x01010101)], (0, 2): [(0xF0F00000, 0x20010000)], (1, 3): [(0x1234FFFF, 0x43210001)]}
    for mode in (0, 1):
        for op in range(4):
            name = f"{'8' if mode == 0 else '16'}-bit lanes: {names[op]}"
            for a, b in fixed.get((mode, op), []) + [(0xFFFFFFFF, 0x00000001), (0x00000000, 0x00000001), (0x80808080, 0x80808080), (0x7FFF8000, 0x80017FFF)]:
                yield name, {"a": a, "b": b, "mode": mode, "op": op}, e(a, b, mode, op)
            for _ in range(300):
                a, b = rnd.getrandbits(32), rnd.getrandbits(32)
                yield name, {"a": a, "b": b, "mode": mode, "op": op}, e(a, b, mode, op)
