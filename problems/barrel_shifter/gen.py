import random

CLOCK = None
PARAMS = {"WIDTH": 16}
W, M = 16, 0xFFFF
NAMES = ["SLL", "SRL", "SRA", "ROR"]


def f(d, k, op):
    if op == 0: return (d << k) & M
    if op == 1: return d >> k
    if op == 2: return ((d - (1 << W) if d >> (W - 1) else d) >> k) & M
    return ((d >> k) | (d << (W - k))) & M


def vectors():
    rnd = random.Random(51)
    for op in range(4):
        for d in [0x00F1, 0x8010, 0x000F, 0xFFFF, 0x8000, 0x0001, 0xA5A5]:
            for k in range(16):
                yield NAMES[op], {"din": d, "shamt": k, "op": op}, {"dout": f(d, k, op)}
        for _ in range(400):
            d, k = rnd.getrandbits(16), rnd.getrandbits(4)
            yield NAMES[op], {"din": d, "shamt": k, "op": op}, {"dout": f(d, k, op)}
