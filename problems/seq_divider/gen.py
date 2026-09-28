import random

CLOCK = "clk"


def div(n, d):
    if d == 0:
        return 0xFFFF, n
    return n // d, n % d


def vectors():
    rnd = random.Random(64)
    busy, k, done, q, r, ops = 0, 0, 0, 0, 0, (0, 1)

    def step(name, start=0, n=0, d=0, rst=0):
        nonlocal busy, k, done, q, r, ops
        done = 0
        if rst:
            busy, q, r = 0, 0, 0
        elif busy:
            k += 1
            if k == 16:
                busy, done = 0, 1
                q, r = div(*ops)
        elif start:
            busy, k, ops = 1, 0, (n, d)
        return name, {"rst": rst, "start": start, "dividend": n, "divisor": d}, \
            {"busy": busy, "done": done, "quotient": q, "remainder": r}

    def op(name, n, d, extra=False):
        yield step(name, 1, n, d)
        for i in range(18):
            yield step(name, int(extra and i == 3), rnd.getrandbits(16), rnd.getrandbits(16))

    yield step("reset", rst=1)
    yield step("reset")
    yield from op("single division", 100, 7)
    for n, d in [(1234, 0), (0, 0)]:
        yield from op("divide by zero", n, d)
    for n, d in [(65535, 1), (65535, 65535), (5, 9), (0, 3), (32768, 2), (65535, 256)]:
        yield from op("edge cases", n, d)
    yield from op("start ignored while busy", 999, 10, extra=True)
    for _ in range(100):
        d = rnd.choice([rnd.getrandbits(16), rnd.getrandbits(8), rnd.getrandbits(4) + 1])
        yield from op("100 random divisions", rnd.getrandbits(16), d)
