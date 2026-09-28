import random

CLOCK = "clk"


def pc(x):
    return bin(x).count("1")


def vectors():
    rnd = random.Random(199)
    st = {"bus": 0, "inv": 0, "tog": 0, "last": 0}

    def step(name, v=0, d=0, rst=0):
        if rst:
            st.update(bus=0, inv=0, tog=0, last=0)
        elif v:
            if pc(d ^ st["bus"]) > 4:
                nb, ni = (~d) & 0xFF, 1
            else:
                nb, ni = d, 0
            st["tog"] = (st["tog"] + pc(nb ^ st["bus"]) + (ni ^ st["inv"])) & 0xFFFF
            st["bus"], st["inv"] = nb, ni
        return name, {"rst": rst, "valid": v, "din": d}, \
            {"bus_q": st["bus"], "inv": st["inv"], "dout": st["bus"] ^ (0xFF if st["inv"] else 0), "toggles": st["tog"]}

    yield step("inverts when more than half the bits flip", rst=1)
    yield step("inverts when more than half the bits flip", 1, 0xFE)
    yield step("inverts when more than half the bits flip", 1, 0x01)
    yield step("no inversion at exactly 4", rst=1)
    yield step("no inversion at exactly 4", 1, 0x0F)
    yield step("no inversion at exactly 4", 1, 0xF0)
    yield step("no inversion at exactly 4", 1, 0xF1)
    yield step("holds without valid", 0, 0x00)
    yield step("holds without valid", 0, 0xAA)
    for _ in range(3000):
        yield step("decoder recovers data (3000 random words)", int(rnd.random() < 0.8), rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
