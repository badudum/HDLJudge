import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(267)
    st = []

    def step(name, push=0, pop=0, a=0, rst=0):
        if rst:
            st.clear()
        elif push and pop:
            if st:
                st[-1] = a
            else:
                st.append(a)
        elif push:
            st.append(a)
            if len(st) > 4:
                st.pop(0)
        elif pop and st:
            st.pop()
        return name, {"rst": rst, "push": push, "pop": pop, "addr": a}, {"top": st[-1] if st else 0, "count": len(st)}

    yield step("call and return", rst=1)
    yield step("call and return", 1, 0, 0x10)
    yield step("call and return", 1, 0, 0x20)
    yield step("call and return", 0, 1)
    yield step("call and return", 0, 1)
    yield step("call and return", 0, 1)
    for a in (1, 2, 3, 4, 5):
        yield step("overflow keeps the newest", 1, 0, a)
    for _ in range(5):
        yield step("overflow keeps the newest", 0, 1)
    yield step("tail call replaces the top", 1, 0, 0x33)
    yield step("tail call replaces the top", 1, 1, 0x44)
    for _ in range(3000):
        r = rnd.random()
        yield step("3000 random cycles", int(r < 0.4 or r > 0.95), int(0.4 <= r < 0.8 or r > 0.95), rnd.getrandbits(8), rst=int(rnd.random() < 0.003))
