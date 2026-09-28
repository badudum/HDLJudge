import math
import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(220)
    st = {"busy": 0, "n": 0, "x": 0, "root": 0, "done": 0}

    def step(name, start=0, x=0, rst=0):
        st["done"] = 0
        if rst:
            st.update(busy=0, n=0, root=0)
        elif st["busy"]:
            st["n"] += 1
            if st["n"] == 8:
                st.update(busy=0, done=1, root=math.isqrt(st["x"]))
        elif start:
            st.update(busy=1, n=0, x=x)
        return name, {"rst": rst, "start": start, "x": x}, \
            {"busy": st["busy"], "done": st["done"], "root": None if st["busy"] else st["root"]}

    def run(name, x):
        yield step(name, 1, x)
        for _ in range(8):
            yield step(name, 0, 0)

    yield step("perfect squares", rst=1)
    for x in (0, 1, 4, 144, 10000, 65025):
        yield from run("perfect squares", x)
    for x in (2, 3, 15, 65535, 65024, 99):
        yield from run("largest input and non-squares", x)
    yield step("start while busy is ignored", 1, 400)
    for _ in range(3):
        yield step("start while busy is ignored", 1, 9)
    for _ in range(6):
        yield step("start while busy is ignored")
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.3), rnd.getrandbits(16), rst=int(rnd.random() < 0.002))
