import random

CLOCK = None
M = 0xFFFFFFFF


def s(v):
    return v - (1 << 32) if v >> 31 else v


def taken(a, b, f):
    return {0: a == b, 1: a != b, 4: s(a) < s(b), 5: s(a) >= s(b), 6: a < b, 7: a >= b}.get(f, False)


def vectors():
    rnd = random.Random(47)
    corners = [0, 1, 5, 0x7FFFFFFF, 0x80000000, 0xFFFFFFFF, 0xFFFFFFFE]
    groups = [("BEQ / BNE", [0, 1]), ("BLT / BGE (signed)", [4, 5]), ("BLTU / BGEU (unsigned)", [6, 7]), ("non-branch funct3 never taken", [2, 3])]
    for name, fs in groups:
        for f in fs:
            for a in corners:
                for b in corners:
                    yield name, {"a": a, "b": b, "funct3": f}, {"taken": int(taken(a, b, f))}
            for _ in range(200):
                a = rnd.getrandbits(32)
                b = a if rnd.random() < 0.2 else rnd.getrandbits(32)
                yield name, {"a": a, "b": b, "funct3": f}, {"taken": int(taken(a, b, f))}
