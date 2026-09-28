import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(224)
    st = {"cr": 4, "tv": 0, "td": 0}
    inflight = []

    def step(name, iv=0, d=0, ret=0, rst=0):
        if rst:
            st.update(cr=4, tv=0)
            inflight.clear()
            ret = 0
        else:
            send = iv and st["cr"] != 0
            st["tv"] = int(send)
            if send:
                st["td"] = d
            st["cr"] += ret - int(send)
        return name, {"rst": rst, "in_valid": iv, "in_data": d, "credit_ret": ret}, \
            {"in_ready": int(st["cr"] != 0), "tx_valid": st["tv"], "tx_data": st["td"] if st["tv"] else None, "credits": st["cr"]}

    yield step("stops at zero credits", rst=1)
    for i in range(6):
        yield step("stops at zero credits", 1, i)
    yield step("simultaneous send and return", 1, 9, 1)
    yield step("simultaneous send and return", 1, 10, 1)
    yield step("simultaneous send and return", 0, 0, 1)
    # random: receiver returns credits a few cycles after words arrive
    owed = 0
    for _ in range(3000):
        ret = 1 if owed and rnd.random() < 0.4 else 0
        v = step("3000 random cycles", int(rnd.random() < 0.7), rnd.getrandbits(8), ret, rst=int(rnd.random() < 0.002))
        owed = 0 if v[1]["rst"] else owed - ret + v[2]["tx_valid"]
        yield v
