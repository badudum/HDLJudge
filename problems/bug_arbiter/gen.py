import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(28)
    ptr, grant = 0, 0

    def step(name, req, rst=0):
        nonlocal ptr, grant
        if rst:
            ptr, grant = 0, 0
        else:
            grant = 0
            for k in range(4):
                j = (ptr + k) % 4
                if (req >> j) & 1:
                    grant, ptr = 1 << j, (j + 1) % 4
                    break
        return name, {"rst": rst, "req": req}, {"grant": grant}

    yield step("all requesting: strict rotation", 0xF, rst=1)
    for _ in range(12):
        yield step("all requesting: strict rotation", 0xF)
    for _ in range(6):
        yield step("single requester is granted every cycle", 0x4)
    yield step("fairness: pointer skips idle requesters", 0x0, rst=1)
    for r in [0x1, 0x9, 0x9, 0x9, 0x6, 0x6, 0x6, 0x0, 0x0, 0x8, 0x1]:
        yield step("fairness: pointer skips idle requesters", r)
    for r in [0x0, 0x0, 0x2, 0x0, 0x2]:
        yield step("no request: grant 0 and pointer unchanged", r)
    for _ in range(2000):
        yield step("2000 random request patterns", rnd.getrandbits(4), rst=int(rnd.random() < 0.003))
