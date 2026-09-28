import random

CLOCK = None
PARAMS = {"WIDTH": 16}
W = 16
M = (1 << W) - 1
NAMES = ["ADD", "SUB", "AND", "OR", "XOR", "NOR", "SLL", "SRL", "SRA", "SLT", "SLTU"]


def s(v):
    return v - (1 << W) if v >> (W - 1) else v


def alu(a, b, op):
    sh = b & (W - 1)
    carry = ovf = 0
    if op == 0:
        t = a + b
        y, carry = t & M, t >> W
        ovf = int((a >> 15) == (b >> 15) and (y >> 15) != (a >> 15))
    elif op == 1:
        t = a + (~b & M) + 1
        y, carry = t & M, t >> W
        ovf = int((a >> 15) != (b >> 15) and (y >> 15) != (a >> 15))
    elif op == 2: y = a & b
    elif op == 3: y = a | b
    elif op == 4: y = a ^ b
    elif op == 5: y = ~(a | b) & M
    elif op == 6: y = (a << sh) & M
    elif op == 7: y = a >> sh
    elif op == 8: y = (s(a) >> sh) & M
    elif op == 9: y = int(s(a) < s(b))
    elif op == 10: y = int(a < b)
    else: y = 0
    return {"y": y, "zero": int(y == 0), "carry": carry, "overflow": ovf, "negative": y >> (W - 1)}


def vectors():
    rnd = random.Random(44)
    corners = [0, 1, 2, 0x7FFF, 0x8000, 0x8001, 0xFFFF, 0xFFFE, 0x5555, 0xAAAA, 0x00FF]
    for op in range(16):
        name = NAMES[op] if op < len(NAMES) else "unused opcodes give 0"
        for a in corners:
            for b in corners:
                yield name, {"a": a, "b": b, "op": op}, alu(a, b, op)
        if op < len(NAMES):
            for _ in range(150):
                a, b = rnd.getrandbits(16), rnd.getrandbits(16)
                yield name, {"a": a, "b": b, "op": op}, alu(a, b, op)
