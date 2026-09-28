import random
from collections import deque

CLOCK = "clk"


def vectors():
    rnd = random.Random(66)
    rat = list(range(8))
    free = deque(range(8, 16))
    out = {"ren_ok": 0, "stall": 0, "ps1": None, "ps2": None, "pd": None, "old_pd": None}
    retire = deque()          # old_pds waiting to be freed (in program order)

    def step(name, rv=0, rs1=0, rs2=0, rd=0, has=0, fv=0, fp=0, rst=0):
        nonlocal rat, free, out
        if rst:
            rat, free = list(range(8)), deque(range(8, 16))
            out = {"ren_ok": 0, "stall": 0, "ps1": None, "ps2": None, "pd": None, "old_pd": None}
        else:
            o = {"ren_ok": 0, "stall": 0, "ps1": None, "ps2": None, "pd": None, "old_pd": None}
            if rv:
                o["ps1"], o["ps2"] = rat[rs1], rat[rs2]
                if has:
                    if free:
                        pd = free.popleft()
                        o.update(ren_ok=1, pd=pd, old_pd=rat[rd])
                        retire.append(rat[rd])
                        rat[rd] = pd
                    else:
                        o["stall"] = 1
                else:
                    o["ren_ok"] = 1
            if fv:
                free.append(fp)
            out = o
        return name, {"rst": rst, "ren_valid": rv, "rs1": rs1, "rs2": rs2, "rd": rd, "has_rd": has,
                      "free_valid": fv, "free_preg": fp}, dict(out)

    yield step("reset", rst=1)
    yield step("first renames", 1, 1, 2, 3, 1)
    yield step("dependency chain through the RAT", 1, 3, 3, 4, 1)
    yield step("dependency chain through the RAT", 1, 4, 3, 3, 1)
    yield step("instruction without a destination", 1, 3, 4, 0, 0)
    for i in range(7):
        yield step("free list exhaustion stalls", 1, i % 8, (i + 1) % 8, (i + 2) % 8, 1)
    yield step("freed register is reused next cycle", 1, 0, 0, 1, 1, 1, retire.popleft())
    yield step("freed register is reused next cycle", 1, 0, 0, 2, 1)
    for _ in range(3000):
        fv = int(bool(retire) and rnd.random() < 0.45)
        fp = retire.popleft() if fv else rnd.getrandbits(4)
        yield step("3000 random rename / free cycles", int(rnd.random() < 0.8), rnd.getrandbits(3), rnd.getrandbits(3),
                   rnd.getrandbits(3), int(rnd.random() < 0.8), fv, fp)
