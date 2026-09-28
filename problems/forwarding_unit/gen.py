import random

CLOCK = None


def sel(rs, mrd, mw, wrd, ww):
    if mw and mrd != 0 and mrd == rs:
        return 2
    if ww and wrd != 0 and wrd == rs:
        return 1
    return 0


def mk(r1, r2, mrd, mw, wrd, ww):
    i = {"ex_rs1": r1, "ex_rs2": r2, "mem_rd": mrd, "mem_reg_write": mw, "wb_rd": wrd, "wb_reg_write": ww}
    return i, {"fwd_a": sel(r1, mrd, mw, wrd, ww), "fwd_b": sel(r2, mrd, mw, wrd, ww)}


def vectors():
    rnd = random.Random(55)
    for args in [(3, 9, 3, 1, 0, 0), (9, 3, 3, 1, 0, 0), (3, 3, 3, 1, 7, 1)]:
        yield ("EX/MEM forwarding",) + mk(*args)
    for args in [(3, 9, 8, 1, 3, 1), (9, 3, 8, 0, 3, 1), (3, 9, 3, 0, 3, 1)]:
        yield ("MEM/WB forwarding",) + mk(*args)
    for args in [(4, 4, 4, 1, 4, 1), (4, 1, 4, 1, 4, 1)]:
        yield ("priority: EX/MEM beats MEM/WB",) + mk(*args)
    for args in [(0, 0, 0, 1, 0, 1), (0, 5, 0, 1, 5, 0), (6, 7, 6, 0, 7, 0)]:
        yield ("never forward x0 or non-writing stages",) + mk(*args)
    for _ in range(3000):
        pick = lambda: rnd.choice([0, 1, 2, 3, rnd.getrandbits(5)])
        yield ("3000 random pipeline states",) + mk(pick(), pick(), pick(), rnd.getrandbits(1), pick(), rnd.getrandbits(1))
