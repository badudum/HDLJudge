import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(269)
    st = {"prev": 0, "acc": 0, "n": 0, "act": 0, "hot": 0}

    def step(name, bus=0, th=0, rst=0):
        if rst:
            st.update(prev=0, acc=0, n=0, act=0, hot=0)
        else:
            acc = st["acc"] + bin(bus ^ st["prev"]).count("1")
            st["prev"] = bus
            if st["n"] == 15:
                st["act"] = acc
                st["hot"] = int(acc > th)
                st["acc"], st["n"] = 0, 0
            else:
                st["acc"], st["n"] = acc, st["n"] + 1
        return name, {"rst": rst, "bus": bus, "threshold": th}, {"activity": st["act"], "hot": st["hot"]}

    yield step("counts toggles per window", rst=1)
    for k in range(16):
        yield step("counts toggles per window", 0xFF if k % 2 == 0 else 0x00, 100)
    for k in range(16):
        yield step("counts toggles per window", 0x00, 100)
    for k in range(16):
        yield step("counts toggles per window", 1 << (k % 8), 10)
    for _ in range(3000):
        yield step("3000 random cycles", rnd.getrandbits(8) if rnd.random() < 0.5 else rnd.getrandbits(2), rnd.getrandbits(7), rst=int(rnd.random() < 0.002))
