import random

CLOCK = "clk"


def s8(v):
    return v - 256 if v >= 128 else v


def vectors():
    rnd = random.Random(225)
    st = {"busy": 0, "n": 0, "a": 0, "b": 0, "p": 0, "done": 0}

    def step(name, start=0, a=0, b=0, rst=0):
        st["done"] = 0
        if rst:
            st.update(busy=0, n=0, p=0)
        elif st["busy"]:
            st["n"] += 1
            if st["n"] == 8:
                st.update(busy=0, done=1, p=(s8(st["a"]) * s8(st["b"])) & 0xFFFF)
        elif start:
            st.update(busy=1, n=0, a=a, b=b)
        return name, {"rst": rst, "start": start, "a": a, "b": b}, \
            {"busy": st["busy"], "done": st["done"], "p": None if st["busy"] else st["p"]}

    def run(name, a, b):
        yield step(name, 1, a, b)
        for _ in range(8):
            yield step(name)

    yield step("signs", rst=1)
    for a, b in ((0xFD, 5), (5, 0xFD), (0xFD, 0xFB), (7, 9)):
        yield from run("signs", a, b)
    for a in (0, 1, 0x7F, 0x80, 0xFF):
        for b in (0, 1, 0x7F, 0x80, 0xFF):
            yield from run("corner cases", a, b)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.3), rnd.getrandbits(8), rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
