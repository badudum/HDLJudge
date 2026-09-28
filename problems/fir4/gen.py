import random

CLOCK = "clk"


def s8(v):
    return v - 256 if v >= 128 else v


def vectors():
    rnd = random.Random(218)
    st = {"x": [0, 0, 0], "y": 0}

    def step(name, v=0, d=0, rst=0):
        if rst:
            st.update(x=[0, 0, 0], y=0)
        elif v:
            x = st["x"]
            st["y"] = s8(d) + 3 * x[0] + 3 * x[1] + x[2]
            st["x"] = [s8(d), x[0], x[1]]
        return name, {"rst": rst, "valid": v, "din": d}, {"dout": st["y"] & 0xFFF}

    yield step("impulse response", rst=1)
    for d in (1, 0, 0, 0, 0):
        yield step("impulse response", 1, d)
    for _ in range(5):
        yield step("negative samples", 1, 0x80)
    for _ in range(5):
        yield step("negative samples", 1, 0x7F)
    yield step("valid gates the filter", 0, 0x33)
    for _ in range(3000):
        yield step("3000 random samples", int(rnd.random() < 0.8), rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
