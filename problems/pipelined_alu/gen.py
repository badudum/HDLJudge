import random

CLOCK = "clk"


def alu(op, a, b):
    return [(a + b), (a - b), (a & b), (a ^ b)][op] & 0xFFFF


def vectors():
    rnd = random.Random(166)
    s1 = (0, 0, 0, 0)
    s2 = (0, 0)

    def step(name, v=0, op=0, a=0, b=0, stall=0, rst=0):
        nonlocal s1, s2
        if rst:
            s1, s2 = (0, 0, 0, 0), (0, 0)
        elif not stall:
            s2 = (s1[0], alu(s1[1], s1[2], s1[3]))
            s1 = (v, op, a, b)
        out = {"valid_out": s2[0], "y": s2[1] if s2[0] else None, "zero": int(s2[1] == 0) if s2[0] else None}
        return name, {"rst": rst, "stall": stall, "valid_in": v, "op": op, "a": a, "b": b}, out

    yield step("latency 2", rst=1)
    yield step("latency 2", 1, 0, 3, 4)
    yield step("latency 2", 1, 1, 3, 4)
    yield step("latency 2", 1, 2, 0xF0F0, 0x0FF0)
    yield step("latency 2", 1, 3, 0x1234, 0x1234)
    yield step("latency 2")
    yield step("latency 2")
    yield step("stall freezes the pipeline", 1, 0, 100, 1)
    yield step("stall freezes the pipeline", 1, 0, 200, 1)
    for _ in range(3):
        yield step("stall freezes the pipeline", 1, 0, 999, 999, stall=1)
    yield step("stall freezes the pipeline")
    yield step("stall freezes the pipeline")
    for v in (1, 0, 1, 0, 0, 0):
        yield step("bubbles flow through", v, 0, 1, 1)
    for _ in range(2500):
        yield step("2500 random cycles", int(rnd.random() < 0.8), rnd.getrandbits(2), rnd.getrandbits(16), rnd.choice([rnd.getrandbits(16), 0]),
                   stall=int(rnd.random() < 0.2), rst=int(rnd.random() < 0.003))
