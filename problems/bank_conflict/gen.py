import random

CLOCK = None


def pack(a):
    return sum(x << (8 * i) for i, x in enumerate(a))


def e(a, v):
    banks = {}
    for i in range(4):
        if v >> i & 1:
            banks.setdefault(a[i] & 3, set()).add(a[i])
    c = max((len(s) for s in banks.values()), default=0)
    return {"cycles": c, "conflict": int(c > 1)}


def vectors():
    rnd = random.Random(50)
    for a in [[0, 1, 2, 3], [7, 4, 5, 6], [100, 101, 102, 103]]:
        yield "no conflict", {"addr": pack(a), "valid": 15}, e(a, 15)
    for a in [[8, 8, 8, 8], [3, 3, 7, 7], [9, 9, 9, 13]]:
        yield "broadcast (same word) is not a conflict", {"addr": pack(a), "valid": 15}, e(a, 15)
    for a in [[0, 4, 8, 12], [0, 4, 0, 5], [1, 5, 9, 1], [2, 6, 3, 7]]:
        yield "conflicts", {"addr": pack(a), "valid": 15}, e(a, 15)
    for a, v in [([0, 4, 8, 12], 0b0001), ([0, 4, 8, 12], 0), ([0, 4, 8, 12], 0b1010), ([1, 5, 1, 5], 0b0011)]:
        yield "inactive lanes are ignored", {"addr": pack(a), "valid": v}, e(a, v)
    for _ in range(3000):
        a = [rnd.choice([rnd.getrandbits(8), rnd.getrandbits(4), rnd.getrandbits(3) * 4]) for _ in range(4)]
        v = rnd.getrandbits(4)
        yield "3000 random accesses", {"addr": pack(a), "valid": v}, e(a, v)
