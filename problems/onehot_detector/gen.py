import random

CLOCK = None


def exp(x):
    n = bin(x).count("1")
    return {"onehot": int(n == 1), "onehot0": int(n <= 1)}


def vectors():
    rnd = random.Random(9)
    yield "zero input", {"x": 0}, exp(0)
    for i in range(16):
        yield "single bit set (all 16 positions)", {"x": 1 << i}, exp(1 << i)
    for i in range(16):
        for j in range(i + 1, 16):
            v = (1 << i) | (1 << j)
            yield "two bits set (all 120 pairs)", {"x": v}, exp(v)
    for v in [0xFFFF, 0x7FFF, 0xFFFE, 0x8001, 0xC000, 0x0003, 0x5555, 0xAAAA, 0x8000, 0x0001]:
        yield "edge patterns (all ones, MSB/LSB, alternating)", {"x": v}, exp(v)
    for _ in range(3000):
        k = rnd.choice([1, 1, 2, 3, 16])
        v = rnd.getrandbits(16) if k == 16 else sum(1 << b for b in rnd.sample(range(16), k))
        yield "3000 random values", {"x": v}, exp(v)
