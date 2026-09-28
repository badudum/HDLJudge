import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(198)
    st = {"aa": 0, "ab": 0, "ma": 0, "mb": 0, "op": 0}

    def step(name, en=0, op=0, a=0, b=0, rst=0):
        if rst:
            st.update(aa=0, ab=0, ma=0, mb=0, op=0)
        elif en:
            if op:
                st["ma"], st["mb"] = a, b
            else:
                st["aa"], st["ab"] = a, b
            st["op"] = op
        y = (st["ma"] * st["mb"]) if st["op"] else (st["aa"] + st["ab"])
        return name, {"rst": rst, "en": en, "op": op, "a": a, "b": b}, \
            {"y": y & 0xFFFF, "add_in": (st["aa"] << 8) | st["ab"], "mul_in": (st["ma"] << 8) | st["mb"]}

    yield step("results", rst=1)
    yield step("results", 1, 1, 12, 11)
    yield step("results", 1, 0, 200, 100)
    yield step("results", 1, 1, 255, 255)
    for a, b in ((1, 2), (3, 4), (250, 7)):
        yield step("unused unit's operands hold", 1, 0, a, b)
    for a, b in ((9, 9), (0, 77)):
        yield step("unused unit's operands hold", 1, 1, a, b)
    yield step("disabled holds everything", 0, 0, 5, 5)
    yield step("disabled holds everything", 0, 1, 6, 6)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.6), rnd.getrandbits(1), rnd.getrandbits(8), rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
