import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(219)
    st = {"busy": 0, "k": 0, "d": 0, "tx": 0}

    def half(d, k):
        b = (d >> (7 - k // 2)) & 1
        return 1 - b if k % 2 == 0 else b

    def step(name, load=0, d=0, rst=0):
        if rst:
            st.update(busy=0, k=0, tx=0)
        elif st["busy"]:
            st["k"] += 1
            if st["k"] == 16:
                st.update(busy=0, tx=0)
            else:
                st["tx"] = half(st["d"], st["k"])
        elif load:
            st.update(busy=1, k=0, d=d)
            st["tx"] = half(d, 0)
        return name, {"rst": rst, "load": load, "data": d}, {"tx": st["tx"], "busy": st["busy"]}

    yield step("encodes one byte", rst=1)
    yield step("encodes one byte", 1, 0xA5)
    for _ in range(17):
        yield step("encodes one byte")
    yield step("load while busy is ignored", 1, 0xFF)
    for i in range(8):
        yield step("load while busy is ignored", 1, 0x00)
    for _ in range(10):
        yield step("load while busy is ignored")
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.2), rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
