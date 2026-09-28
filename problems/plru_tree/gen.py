import random

CLOCK = "clk"


def victim(b):
    n = 0
    for _ in range(3):
        n = 2 * n + 1 + ((b >> n) & 1)
    return n - 7


def update(b, w):
    n = 0
    for lvl in range(3):
        right = (w >> (2 - lvl)) & 1
        b = (b & ~(1 << n)) | ((1 - right) << n)
        n = 2 * n + 1 + right
    return b


def vectors():
    rnd = random.Random(58)
    bits = 0

    def step(name, touch=0, way=0, rst=0):
        nonlocal bits
        if rst:
            bits = 0
        elif touch:
            bits = update(bits, way)
        return name, {"rst": rst, "touch": touch, "way": way}, {"victim": victim(bits), "bits": bits}

    yield step("reset", rst=1)
    yield step("single touch", 1, 0)
    yield step("single touch", 1, 7)
    yield step("fill all ways in victim order", rst=1)
    for _ in range(8):
        yield step("fill all ways in victim order", 1, victim(bits))
    for _ in range(2000):
        yield step("2000 random accesses", int(rnd.random() < 0.85), rnd.getrandbits(3), rst=int(rnd.random() < 0.005))
