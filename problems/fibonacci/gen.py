import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(77)
    prev, cur, ovf = 1, 0, 0

    def step(name, en=1, rst=0):
        nonlocal prev, cur, ovf
        if rst:
            prev, cur, ovf = 1, 0, 0
        elif en and not ovf:
            nxt = prev + cur
            if nxt > 0xFFFF:
                ovf = 1
            else:
                prev, cur = cur, nxt
        return name, {"rst": rst, "en": en}, {"fib": cur, "overflow": ovf}

    yield step("sequence", rst=1)
    for _ in range(15):
        yield step("sequence")
    for e in [0, 0, 1, 0]:
        yield step("enable", e)
    for _ in range(15):
        yield step("overflow freezes the output")
    yield step("reset clears overflow", rst=1)
    for _ in range(1000):
        yield step("1000 random cycles", int(rnd.random() < 0.6), rst=int(rnd.random() < 0.02))
