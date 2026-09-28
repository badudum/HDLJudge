import random

CLOCK = None


def pack(v):
    return sum(b << (8 * i) for i, b in enumerate(v))


def e(v):
    m = max(v)
    return {"max": m, "idx": v.index(m)}


def vectors():
    rnd = random.Random(38)
    cases = [[3, 9, 1, 200, 7, 7, 0, 5], [255, 0, 0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 0, 0, 0, 255], [1, 2, 3, 4, 5, 6, 7, 8]]
    for v in cases:
        yield "distinct values", {"x": pack(v)}, e(v)
    for v in [[4, 9, 9, 1, 9, 0, 0, 0], [7, 7, 7, 7, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 3, 3], [1, 5, 2, 5, 3, 5, 4, 5]]:
        yield "ties: lowest index wins", {"x": pack(v)}, e(v)
    for c in [0x00, 0x55, 0xFF]:
        yield "all equal", {"x": pack([c] * 8)}, e([c] * 8)
    for _ in range(3000):
        v = [rnd.getrandbits(8) if rnd.random() < 0.7 else rnd.choice([0, 128, 255]) for _ in range(8)]
        yield "3000 random vectors", {"x": pack(v)}, e(v)
