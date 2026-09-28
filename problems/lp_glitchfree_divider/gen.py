import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(194)
    st = {"q": 0, "cnt": 0, "h": 1}

    def step(name, div, rst=0):
        if rst:
            st.update(q=0, cnt=0, h=div + 1)
        elif st["cnt"] == st["h"] - 1:
            st["cnt"] = 0
            if st["q"] == 0:
                st["h"] = div + 1
            st["q"] ^= 1
        else:
            st["cnt"] += 1
        return name, {"rst": rst, "div": div}, {"clk_out": st["q"]}

    yield step("fixed ratios", 0, rst=1)
    for d in range(4):
        for _ in range(4 * (d + 1) + 2):
            yield step("fixed ratios", d)
    yield step("ratio changes only at period boundaries", 3, rst=1)
    for d in (3, 3, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 3, 3):
        yield step("ratio changes only at period boundaries", d)
    d = 0
    for _ in range(3000):
        if rnd.random() < 0.08:
            d = rnd.getrandbits(2)
        yield step("3000 cycles with random ratio changes", d, rst=int(rnd.random() < 0.002))
