import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(67)
    pend, iss = 0, 0

    def step(name, iv=0, rd=0, rs1=0, rs2=0, wv=0, wrd=0, rst=0):
        nonlocal pend, iss
        if rst:
            pend, iss = 0, 0
        else:
            after = pend & ~((1 << wrd) if wv else 0) & 0xFE
            haz = any(after >> r & 1 for r in (rs1, rs2, rd))
            iss = int(bool(iv) and not haz)
            pend = (after | ((1 << rd) if iss else 0)) & 0xFE
        return name, {"rst": rst, "issue_valid": iv, "rd": rd, "rs1": rs1, "rs2": rs2, "wb_valid": wv, "wb_rd": wrd}, \
            {"issued": iss, "pending": pend}

    yield step("reset", rst=1)
    yield step("RAW stall", 1, 3, 1, 2)
    yield step("RAW stall", 1, 4, 3, 1)
    yield step("RAW stall", 1, 5, 1, 3)
    yield step("writeback bypass wakes the instruction", 1, 4, 3, 1, 1, 3)
    yield step("WAW stall", 1, 4, 1, 1)
    yield step("WAW stall", 1, 4, 1, 1, 1, 4)
    for args in [(1, 0, 1, 2), (1, 1, 0, 0), (1, 0, 0, 0)]:
        yield step("register 0 is never pending", *args)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.8), rnd.getrandbits(3), rnd.getrandbits(3), rnd.getrandbits(3),
                   int(rnd.random() < 0.4), rnd.getrandbits(3), rst=int(rnd.random() < 0.003))
