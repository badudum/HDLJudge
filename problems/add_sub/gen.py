import random

CLOCK = None
PARAMS = {"N": 12}
M = 0xFFF


def e(a, b, s):
    t = a + ((b ^ M) if s else b) + s
    return {"y": t & M, "cout": t >> 12}


def vectors():
    rnd = random.Random(74)
    corners = [0, 1, 0x7FF, 0x800, 0xFFE, 0xFFF, 0x100]
    for s, name in [(0, "add"), (1, "subtract")]:
        for a in corners:
            for b in corners:
                yield name, {"a": a, "b": b, "sub": s}, e(a, b, s)
        for _ in range(1000):
            a, b = rnd.getrandbits(12), rnd.getrandbits(12)
            yield name, {"a": a, "b": b, "sub": s}, e(a, b, s)
