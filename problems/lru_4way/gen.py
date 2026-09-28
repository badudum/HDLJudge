import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(57)
    order = [0, 1, 2, 3]

    def step(name, acc=0, way=0, rst=0):
        nonlocal order
        if rst:
            order = [0, 1, 2, 3]
        elif acc:
            order.remove(way)
            order.append(way)
        return name, {"rst": rst, "touch": acc, "way": way}, {"victim": order[0]}

    yield step("reset order", rst=1)
    yield step("reset order")
    yield step("touch the victim", 1, 0)
    yield step("touch the victim", 1, 1)
    yield step("true LRU order", rst=1)
    for w in [3, 1, 0, 2, 2, 2, 1]:
        yield step("true LRU order", 1, w)
    for w in [1, 2, 3]:
        yield step("no access keeps the state", 0, w)
    for _ in range(2000):
        yield step("2000 random accesses", int(rnd.random() < 0.8), rnd.getrandbits(2), rst=int(rnd.random() < 0.005))
