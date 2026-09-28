import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(264)
    st = {"q": 0}

    def step(name, en=0, rst=0):
        if rst:
            st["q"] = 0
        elif en:
            q = st["q"]
            st["q"] = ((q << 1) & 7) | (1 - (q >> 2 & 1))
        return name, {"rst": rst, "en": en}, {"q": st["q"], "tick": int(st["q"] == 4)}

    yield step("full cycle", rst=1)
    for _ in range(7):
        yield step("full cycle", 1)
    for e in (0, 0, 1, 0):
        yield step("enable", e)
    for _ in range(1000):
        yield step("1000 random cycles", int(rnd.random() < 0.7), rst=int(rnd.random() < 0.01))
