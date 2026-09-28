import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(53)
    st = [[0, 0], [0, 0], [0, 0]]      # S1, S2, S3 as [valid, data]
    seq = [0]

    def step(name, rst=0, stall=0, flush=0, iv=1, d=None):
        nonlocal st
        if d is None:
            seq[0] += 1
            d = (seq[0] * 0x1111) & 0xFFFF
        if rst:
            st = [[0, 0], [0, 0], [0, 0]]
        elif flush:
            st = [[0, st[0][1]], [0, st[1][1]], list(st[1])]
        elif stall:
            pass
        else:
            st = [[iv, d], list(st[0]), list(st[1])]
        v, dat = st[2]
        return name, {"rst": rst, "stall": stall, "flush": flush, "in_valid": iv, "in_data": d}, \
            {"out_valid": v, "out_data": dat if v else None}

    yield step("reset", rst=1)
    for _ in range(8):
        yield step("latency 3, one item per cycle")
    for s in [1, 1, 0, 0, 1, 0, 0, 0]:
        yield step("stall holds every stage", stall=s)
    for f in [0, 0, 0, 1, 0, 0, 0, 0]:
        yield step("flush kills the younger stages", flush=f)
    for f, s in [(1, 1), (0, 0), (0, 0), (0, 0)]:
        yield step("flush has priority over stall", flush=f, stall=s)
    for iv in [1, 0, 1, 0, 0, 1, 1, 0, 0, 0]:
        yield step("bubbles (in_valid = 0) flow through", iv=iv)
    for _ in range(2000):
        r = rnd.random()
        yield step("2000 random cycles", rst=int(r < 0.01), stall=int(rnd.random() < 0.2),
                   flush=int(rnd.random() < 0.08), iv=int(rnd.random() < 0.8))
