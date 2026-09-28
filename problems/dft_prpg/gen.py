import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(238)
    st = {"s": 0xACE1}

    def step(name, load=0, seed=0, en=0, rst=0):
        if rst:
            st["s"] = 0xACE1
        elif load:
            st["s"] = seed
        elif en:
            s = st["s"]
            fb = ((s >> 15) ^ (s >> 13) ^ (s >> 12) ^ (s >> 10)) & 1
            st["s"] = ((s << 1) | fb) & 0xFFFF
        s = st["s"]
        b = lambda i: (s >> i) & 1
        ch = (b(0) ^ b(5)) | ((b(3) ^ b(9)) << 1) | ((b(7) ^ b(12)) << 2) | ((b(2) ^ b(14)) << 3)
        return name, {"rst": rst, "load": load, "seed": seed, "en": en}, {"state": s, "chains": ch}

    yield step("steps from the reset seed", rst=1)
    for _ in range(40):
        yield step("steps from the reset seed", en=1)
    yield step("seed load", load=1, seed=0x1234, en=1)
    yield step("seed load")
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.01), rnd.getrandbits(16) | 1, int(rnd.random() < 0.8), rst=int(rnd.random() < 0.002))
