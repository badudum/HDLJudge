import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(189)
    st = {"s": "OFF", "idle": 0, "saved": 0}

    def step(name, req=0, fo=0, rst=0):
        if rst:
            st.update(s="OFF", idle=0, saved=0)
        else:
            s = st["s"]
            if s == "OFF":
                st["saved"] = (st["saved"] + 1) & 0xFFFF
                if req or fo:
                    st["s"] = "WAKE"
            elif s == "WAKE":
                st["s"] = "ON"; st["idle"] = 0
            else:
                if req or fo:
                    st["idle"] = 0
                elif st["idle"] == 2:
                    st["s"] = "OFF"; st["idle"] = 0
                else:
                    st["idle"] += 1
        s = st["s"]
        return name, {"rst": rst, "req": req, "force_on": fo}, {"cg_en": int(s != "OFF"), "ready": int(s == "ON"), "saved": st["saved"]}

    yield step("wakes on request", rst=1)
    yield step("wakes on request")
    yield step("wakes on request", 1)
    yield step("wakes on request", 1)
    yield step("wakes on request", 1)
    for r in (0, 0, 1, 0, 0, 0, 0):
        yield step("gates after 3 idle cycles", r)
    yield step("force_on disables gating", 0, 1)
    for _ in range(8):
        yield step("force_on disables gating", 0, 1)
    for _ in range(4):
        yield step("force_on disables gating", 0, 0)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.25), int(rnd.random() < 0.03), rst=int(rnd.random() < 0.002))
