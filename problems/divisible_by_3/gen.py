import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(30)
    n = 0

    def step(name, b, rst=0):
        nonlocal n
        n = 0 if rst else 2 * n + b
        return name, {"rst": rst, "din": b}, {"div": int(n % 3 == 0)}

    yield step("reset value 0 is divisible", 0, rst=1)
    yield step("reset value 0 is divisible", 0)
    for bits in ["110", "101", "1001", "1111", "10010"]:
        yield step("short numbers", 0, rst=1)
        for c in bits:
            yield step("short numbers", int(c))
    yield step("very long number (400 bits)", 0, rst=1)
    for _ in range(400):
        yield step("very long number (400 bits)", rnd.getrandbits(1))
    for _ in range(1500):
        yield step("1500 random bits with resets", rnd.getrandbits(1), rst=int(rnd.random() < 0.02))
