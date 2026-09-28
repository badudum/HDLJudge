import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(192)
    st = {"s": "RUN", "pend": 0, "irq": 0}
    pmu = {"ack": 0, "cnt": 0}

    def step(name, sl=0, wi=0, rst=0):
        ack = pmu["ack"]
        s = st["s"]
        irq = 0
        if rst:
            st.update(s="RUN", pend=0)
        elif s == "RUN":
            if wi:
                irq = 1
            elif sl:
                st["s"] = "REQ_OFF"
        elif s == "REQ_OFF":
            p = st["pend"] or wi
            if ack:
                st["s"] = "REQ_ON" if p else "SLEEP"
                st["pend"] = 1 if p else 0
            else:
                st["pend"] = int(p)
        elif s == "SLEEP":
            if wi:
                st["s"] = "REQ_ON"; st["pend"] = 1
        else:
            if wi:
                st["pend"] = 1
            if not ack:
                st["s"] = "RUN"
                irq = st["pend"]
                st["pend"] = 0
        st["irq"] = irq
        req = int(st["s"] in ("REQ_OFF", "SLEEP"))
        # PMU model: ack follows req after a random delay (sampled at the edge)
        if pmu["ack"] != req:
            pmu["cnt"] += 1
            if pmu["cnt"] >= rnd.randint(1, 4):
                pmu["ack"], pmu["cnt"] = req, 0
        else:
            pmu["cnt"] = 0
        if rst:
            pmu.update(ack=0, cnt=0)
        return name, {"rst": rst, "sleep_req": sl, "wake_irq": wi, "pmu_ack": ack}, \
            {"pmu_req": req, "asleep": int(st["s"] == "SLEEP"), "irq_out": st["irq"]}

    yield step("sleep and wake round trip", rst=1)
    yield step("sleep and wake round trip", sl=1)
    for _ in range(8):
        yield step("sleep and wake round trip")
    yield step("sleep and wake round trip", wi=1)
    for _ in range(8):
        yield step("sleep and wake round trip")
    yield step("interrupt while running", wi=1)
    yield step("interrupt while running", wi=1, sl=1)
    yield step("interrupt while running")
    yield step("wake during power-down is not lost", sl=1)
    yield step("wake during power-down is not lost", wi=1)
    for _ in range(12):
        yield step("wake during power-down is not lost")
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.15), int(rnd.random() < 0.06), rst=int(rnd.random() < 0.002))
