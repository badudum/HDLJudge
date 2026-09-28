import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(263)
    st = {"r": 0, "w": 1}

    def step(name, v=0, b=0, rst=0):
        if rst:
            st.update(r=0, w=1)
        elif v:
            st["r"] = (st["r"] + st["w"] * b) % 3
            st["w"] = 3 - st["w"]
        return name, {"rst": rst, "valid": v, "bit_in": b}, {"d3": int(st["r"] == 0)}

    yield step("worked examples", rst=1)
    for b in (0, 1, 1):
        yield step("worked examples", 1, b)
    yield step("worked examples", rst=1)
    for b in (1, 0, 0, 1):                 # 9
        yield step("worked examples", 1, b)
    for _ in range(3000):
        yield step("long numbers", int(rnd.random() < 0.8), rnd.getrandbits(1), rst=int(rnd.random() < 0.01))
