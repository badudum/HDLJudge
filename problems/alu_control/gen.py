CLOCK = None
F3 = {0: None, 1: 6, 2: 9, 3: 10, 4: 4, 5: None, 6: 3, 7: 2}


def ctrl(op, f3, f7):
    if op == 0:
        return 0
    if op == 1:
        return 1
    if f3 == 0:
        return 1 if (op == 2 and f7) else 0
    if f3 == 5:
        return 8 if f7 else 7
    return F3[f3]


def vectors():
    names = {0: "load/store -> ADD", 1: "branch -> SUB", 2: "R-type decode", 3: "I-type decode"}
    for op in range(4):
        for f3 in range(8):
            for f7 in range(2):
                yield names[op], {"alu_op": op, "funct3": f3, "funct7_5": f7}, {"alu_ctrl": ctrl(op, f3, f7)}
