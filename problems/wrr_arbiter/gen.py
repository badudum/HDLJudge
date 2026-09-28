import random

CLOCK = "clk"
W = (3, 2, 1)


def vectors():
    rnd = random.Random(223)
    st = {"cur": 2, "cnt": 1, "g": 0}

    def step(name, req, rst=0):
        if rst:
            st.update(cur=2, cnt=1, g=0)
        else:
            c = st["cur"]
            if (req >> c) & 1 and st["cnt"] < W[c]:
                st["cnt"] += 1
                st["g"] = 1 << c
            else:
                for k in (1, 2, 0):
                    i = (c + k) % 3
                    if (req >> i) & 1:
                        st.update(cur=i, cnt=1, g=1 << i)
                        break
                else:
                    st["g"] = 0
        return name, {"rst": rst, "req": req}, {"gnt": st["g"]}

    yield step("bandwidth shares", 0, rst=1)
    for _ in range(18):
        yield step("bandwidth shares", 7)
    yield step("turn ends when the request drops", 0, rst=1)
    for r in (1, 6, 6, 5, 5, 5, 4, 4, 0, 0, 2, 2, 2, 2):
        yield step("turn ends when the request drops", r)
    for _ in range(3000):
        yield step("3000 random cycles", rnd.choice([rnd.getrandbits(3), 7, 3, 5]), rst=int(rnd.random() < 0.002))
