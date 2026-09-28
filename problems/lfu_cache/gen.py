import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(59)
    c = [0, 0, 0, 0]

    def vic():
        return c.index(min(c))

    def step(name, hit=0, way=0, fill=0, rst=0):
        nonlocal c
        if rst:
            c = [0, 0, 0, 0]
        elif fill:
            c[vic()] = 1
        elif hit:
            c[way] = min(7, c[way] + 1)
            if c[way] == 7:
                c = [x >> 1 for x in c]
        return name, {"rst": rst, "hit": hit, "way": way, "fill": fill}, \
            {"victim": vic(), "counts": sum(x << (3 * i) for i, x in enumerate(c))}

    yield step("reset and fill", rst=1)
    for _ in range(4):
        yield step("reset and fill", fill=1)
    for w in [2, 2, 2, 0]:
        yield step("frequency wins", hit=1, way=w)
    yield step("frequency wins", fill=1)
    yield step("aging halves all counters", rst=1)
    for w in [0] * 6 + [1] + [2, 2] + [3, 3, 3]:
        yield step("aging halves all counters", hit=1, way=w)
    yield step("aging halves all counters", hit=1, way=0)
    yield step("fill has priority over hit", hit=1, way=3, fill=1)
    for _ in range(2500):
        r = rnd.random()
        yield step("2500 random hits and fills", hit=int(r < 0.7), way=rnd.getrandbits(2),
                   fill=int(rnd.random() < 0.2), rst=int(rnd.random() < 0.003))
