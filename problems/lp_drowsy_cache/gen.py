import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(196)
    st = {"data": [0] * 8, "dz": 0xFF, "cyc": 0, "wk": 0, "ready": 0, "rdata": None}

    def step(name, req=0, we=0, ln=0, wd=0, rst=0):
        if rst:
            st.update(data=[0] * 8, dz=0xFF, cyc=0, wk=0, ready=0, rdata=None)
        else:
            wake = 0
            st["ready"], st["rdata"] = 0, None
            if req:
                if (st["dz"] >> ln) & 1:
                    wake = 1 << ln
                    st["wk"] = (st["wk"] + 1) & 0xFF
                else:
                    st["ready"] = 1
                    if we:
                        st["data"][ln] = wd
                    else:
                        st["rdata"] = st["data"][ln]
            wrap = st["cyc"] == 15
            st["cyc"] = (st["cyc"] + 1) & 15
            st["dz"] = 0xFF if wrap else (st["dz"] & ~wake & 0xFF)
        return name, {"rst": rst, "req": req, "we": we, "idx": ln, "wdata": wd}, \
            {"ready": st["ready"], "rdata": st["rdata"], "drowsy": st["dz"], "wakeups": st["wk"]}

    yield step("first access wakes the line", rst=1)
    yield step("first access wakes the line", 1, 0, 3)
    yield step("first access wakes the line", 1, 0, 3)
    yield step("first access wakes the line", 1, 1, 3, 0x3C)
    yield step("first access wakes the line", 1, 0, 3)
    for _ in range(14):
        yield step("periodic drowsy window")
    yield step("data survives drowsy mode", 1, 0, 3)
    yield step("data survives drowsy mode", 1, 0, 3)
    for _ in range(3000):
        yield step("3000 random accesses", int(rnd.random() < 0.6), rnd.getrandbits(1), rnd.choice([rnd.getrandbits(3), 0, 1]),
                   rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
