import random

CLOCK = None


def e(t):
    return {"count": t.bit_length(), "err": int((t & (t + 1)) != 0)}


def vectors():
    rnd = random.Random(21)
    for k in range(16):
        t = (1 << k) - 1
        yield "valid codes (all 16 levels)", {"t": t}, e(t)
    for k in range(2, 16):
        for b in range(k - 1):
            t = ((1 << k) - 1) ^ (1 << b)
            yield "single bubbles inside the run", {"t": t}, e(t)
    for k in range(15):
        t = ((1 << k) - 1) | (1 << 14)
        yield "stray one above the run", {"t": t}, e(t)
    for _ in range(2000):
        t = rnd.getrandbits(15)
        yield "2000 random codes", {"t": t}, e(t)
