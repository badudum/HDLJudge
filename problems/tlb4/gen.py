import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(268)
    st = {"e": [None] * 4, "ptr": 0}

    def look(v):
        for x in st["e"]:
            if x and x[0] == v:
                return 1, x[1]
        return 0, 0

    def step(name, vpn=0, fill=0, fv=0, fp=0, flush=0, rst=0):
        if rst or flush:
            st["e"] = [None] * 4
            if rst:
                st["ptr"] = 0
        elif fill:
            e = st["e"]
            idx = next((i for i, x in enumerate(e) if x and x[0] == fv), None)
            if idx is None:
                idx = next((i for i, x in enumerate(e) if x is None), None)
                if idx is None:
                    idx = st["ptr"]
                    st["ptr"] = (st["ptr"] + 1) % 4
            e[idx] = (fv, fp)
        h, p = look(vpn)
        return name, {"rst": rst, "vpn": vpn, "fill": fill, "fill_vpn": fv, "fill_ppn": fp, "flush": flush}, {"hit": h, "ppn": p}

    yield step("fill and hit", rst=1)
    yield step("fill and hit", 0x12, 1, 0x12, 0xA0)
    yield step("fill and hit", 0x13)
    for k, v in enumerate((0x20, 0x21, 0x22, 0x23, 0x24)):
        yield step("FIFO replacement", 0x12, 1, v, 0xB0 + k)
    yield step("FIFO replacement", 0x20)
    yield step("FIFO replacement", 0x24)
    yield step("refill updates in place", 0x22, 1, 0x22, 0xEE)
    yield step("flush", 0x22, flush=1, fill=1, fv=0x55, fp=1)
    pages = [rnd.getrandbits(8) for _ in range(7)]
    for _ in range(3000):
        yield step("3000 random cycles", rnd.choice(pages), int(rnd.random() < 0.3), rnd.choice(pages), rnd.getrandbits(8),
                   flush=int(rnd.random() < 0.01), rst=int(rnd.random() < 0.002))
