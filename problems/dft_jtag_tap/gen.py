import random

CLOCK = "tck"
T = {0xF: (0xC, 0xF), 0xC: (0xC, 0x7), 0x7: (0x6, 0x4), 0x6: (0x2, 0x1), 0x2: (0x2, 0x1), 0x1: (0x3, 0x5),
     0x3: (0x3, 0x0), 0x0: (0x2, 0x5), 0x5: (0xC, 0x7), 0x4: (0xE, 0xF), 0xE: (0xA, 0x9), 0xA: (0xA, 0x9),
     0x9: (0xB, 0xD), 0xB: (0xB, 0x8), 0x8: (0xA, 0xD), 0xD: (0xC, 0x7)}


def vectors():
    rnd = random.Random(81)
    s = 0xF

    def step(name, tms, trst=0):
        nonlocal s
        s = 0xF if trst else T[s][tms]
        return name, {"trst": trst, "tms": tms}, {"state": s, "shift_dr": int(s == 0x2), "shift_ir": int(s == 0xA),
                                                   "capture_dr": int(s == 0x6), "update_dr": int(s == 0x5), "tlr": int(s == 0xF)}

    yield step("reset", 1, trst=1)
    yield step("DR scan path", 0)
    for t in [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0]:
        yield step("DR scan path", t)
    for t in [1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0]:
        yield step("IR scan path", t)
    for start_path in range(16):
        yield step("reset by TMS: five ones from every state", 0, trst=1)
        for _ in range(start_path):
            yield step("reset by TMS: five ones from every state", rnd.getrandbits(1))
        for _ in range(5):
            yield step("reset by TMS: five ones from every state", 1)
    for _ in range(2000):
        yield step("2000 random TMS sequences", int(rnd.random() < 0.45), trst=int(rnd.random() < 0.003))
