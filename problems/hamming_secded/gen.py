import itertools

CLOCK = None


def encode(d):
    d0, d1, d2, d3 = [(d >> i) & 1 for i in range(4)]
    p1 = d0 ^ d1 ^ d3
    p2 = d0 ^ d2 ^ d3
    p4 = d1 ^ d2 ^ d3
    bits = [p1, p2, d0, p4, d1, d2, d3]
    w = sum(b << i for i, b in enumerate(bits))
    p0 = bin(w).count("1") & 1
    return w | (p0 << 7)


def vectors():
    for d in range(16):
        yield "clean code words (all 16)", {"code": encode(d)}, {"data": d, "single_err": 0, "double_err": 0}
    for d in range(16):
        for b in range(8):
            yield "single-bit errors (16 x 8)", {"code": encode(d) ^ (1 << b)}, {"data": d, "single_err": 1, "double_err": 0}
    for d in range(16):
        for b1, b2 in itertools.combinations(range(8), 2):
            c = encode(d) ^ (1 << b1) ^ (1 << b2)
            raw = ((c >> 2) & 1) | (((c >> 4) & 1) << 1) | (((c >> 5) & 1) << 2) | (((c >> 6) & 1) << 3)
            yield "double-bit errors (16 x 28)", {"code": c}, {"data": raw, "single_err": 0, "double_err": 1}
