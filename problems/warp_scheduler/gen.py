import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(68)
    ptr, block, iv, iw = 0, [0, 0, 0, 0], 0, 0

    def step(name, ready, rst=0):
        nonlocal ptr, block, iv, iw
        if rst:
            ptr, block, iv, iw = 0, [0, 0, 0, 0], 0, 0
        else:
            elig = [(ready >> w & 1) and block[w] == 0 for w in range(4)]
            block = [max(0, b - 1) for b in block]
            iv = 0
            for k in range(4):
                w = (ptr + k) % 4
                if elig[w]:
                    iv, iw, ptr = 1, w, (w + 1) % 4
                    block[w] = 2
                    break
        return name, {"rst": rst, "ready": ready}, {"issue_valid": iv, "issue_warp": iw if iv else None}

    yield step("reset", 0, rst=1)
    for _ in range(9):
        yield step("all ready: strict rotation", 0xF)
    for _ in range(9):
        yield step("hazard window: single ready warp", 0x4)
    for _ in range(4):
        yield step("no ready warps", 0)
    for r in [0x3, 0x3, 0x3, 0x3, 0x3, 0x3]:
        yield step("two warps alternate with bubbles", r)
    for _ in range(2500):
        yield step("2500 random cycles", rnd.getrandbits(4), rst=int(rnd.random() < 0.003))
