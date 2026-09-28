import random

CLOCK = "clk"
PARAMS = {"K": "0.1"}
K = 0.1


def vectors():
    rnd = random.Random(271)
    st = {"y": 0.0}

    def step(name, x=0.0, rst=0):
        if rst:
            st["y"] = 0.0
        else:
            st["y"] = max(-1.0, min(1.0, st["y"] + K * x))
        return name, {"rst": rst, "x": x}, {"y": st["y"]}

    yield step("ramps and saturates", rst=1)
    for _ in range(12):
        yield step("ramps and saturates", 1.0)
    for _ in range(8):
        yield step("ramps and saturates", -0.5)
    for _ in range(30):
        yield step("negative saturation", -2.0)
    for _ in range(2000):
        yield step("2000 random samples", round(rnd.uniform(-1.5, 1.5), 4), rst=int(rnd.random() < 0.003))
