import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(216)
    st = {"ov": 0, "od": 0, "sv": 0, "sd": 0}

    def step(name, iv=0, d=0, ordy=0, rst=0):
        if rst:
            st.update(ov=0, sv=0)
        else:
            irdy = not st["sv"]
            if (not st["ov"]) or ordy:
                if st["sv"]:
                    st["ov"], st["od"], st["sv"] = 1, st["sd"], 0
                else:
                    st["ov"] = int(iv and irdy)
                    if st["ov"]:
                        st["od"] = d
            elif iv and irdy:
                st["sv"], st["sd"] = 1, d
        return name, {"rst": rst, "in_valid": iv, "in_data": d, "out_ready": ordy}, \
            {"in_ready": int(not st["sv"]), "out_valid": st["ov"], "out_data": st["od"] if st["ov"] else None}

    yield step("full throughput", rst=1)
    for i in range(10):
        yield step("full throughput", 1, i, 1)
    for i, r in ((10, 0), (11, 0), (12, 0), (13, 1), (14, 1), (15, 1), (16, 1)):
        yield step("stall catches the in-flight word", 1, i, r)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.7), rnd.getrandbits(8), int(rnd.random() < 0.6), rst=int(rnd.random() < 0.002))
