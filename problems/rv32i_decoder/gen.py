import random

CLOCK = None
M = 0xFFFFFFFF
OPS = {0b0110011: ("R", 1, 0, 0, 0, 0), 0b0010011: ("I", 1, 0, 0, 0, 0), 0b0000011: ("I", 1, 1, 0, 0, 0),
       0b1100111: ("I", 1, 0, 0, 0, 1), 0b0100011: ("S", 0, 0, 1, 0, 0), 0b1100011: ("B", 0, 0, 0, 1, 0),
       0b0110111: ("U", 1, 0, 0, 0, 0), 0b0010111: ("U", 1, 0, 0, 0, 0), 0b1101111: ("J", 1, 0, 0, 0, 1)}
FMT = {"R": 0, "I": 1, "S": 2, "B": 3, "U": 4, "J": 5}


def bits(x, hi, lo):
    return (x >> lo) & ((1 << (hi - lo + 1)) - 1)


def sext(v, n):
    return (v - (1 << n) if v >> (n - 1) else v) & M


def decode(ins):
    op = ins & 0x7F
    if op not in OPS:
        return {"fmt": 7, "imm": 0, "reg_write": 0, "mem_read": 0, "mem_write": 0, "branch": 0, "jump": 0}
    f, rw, mr, mw, br, j = OPS[op]
    if f == "R": imm = 0
    elif f == "I": imm = sext(bits(ins, 31, 20), 12)
    elif f == "S": imm = sext((bits(ins, 31, 25) << 5) | bits(ins, 11, 7), 12)
    elif f == "B": imm = sext((bits(ins, 31, 31) << 12) | (bits(ins, 7, 7) << 11) | (bits(ins, 30, 25) << 5) | (bits(ins, 11, 8) << 1), 13)
    elif f == "U": imm = ins & 0xFFFFF000
    else: imm = sext((bits(ins, 31, 31) << 20) | (bits(ins, 19, 12) << 12) | (bits(ins, 20, 20) << 11) | (bits(ins, 30, 21) << 1), 21)
    return {"fmt": FMT[f], "imm": imm, "reg_write": rw, "mem_read": mr, "mem_write": mw, "branch": br, "jump": j}


def vectors():
    rnd = random.Random(56)
    groups = {"R": "R-type", "I": "I-type (OP-IMM, LOAD, JALR)", "S": "S-type", "B": "B-type", "U": "U-type", "J": "J-type"}
    fixed = {"I": [0xFFF00093, 0x00A12083, 0x000080E7], "B": [0xFE000EE3], "U": [0x123452B7, 0xFFFFF517], "J": [0x008000EF, 0xFFDFF0EF],
             "S": [0x00112623, 0xFE112E23], "R": [0x002081B3, 0x40208233]}
    for f, name in groups.items():
        for ins in fixed.get(f, []):
            yield name, {"instr": ins}, decode(ins)
        ops = [o for o, v in OPS.items() if v[0] == f]
        for _ in range(400):
            ins = (rnd.getrandbits(25) << 7) | rnd.choice(ops)
            yield name, {"instr": ins}, decode(ins)
    for _ in range(300):
        op = rnd.getrandbits(7)
        while op in OPS:
            op = rnd.getrandbits(7)
        ins = (rnd.getrandbits(25) << 7) | op
        yield "unknown opcodes", {"instr": ins}, decode(ins)
