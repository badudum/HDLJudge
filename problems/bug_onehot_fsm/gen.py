import random

CLOCK = "clk"
IDLE, LOAD, RUN, FLUSH = 1, 2, 4, 8


def vectors():
    rnd = random.Random(93)
    s = IDLE

    def step(name, go=0, done=0, rst=0):
        nonlocal s
        if rst:
            s = IDLE
        elif s == IDLE:
            s = LOAD if go else IDLE
        elif s == LOAD:
            s = RUN
        elif s == RUN:
            s = FLUSH if done else RUN
        else:
            s = IDLE
        return name, {"rst": rst, "go": go, "done": done}, {"state": s, "busy": int(s != IDLE)}

    yield step("reset to IDLE", rst=1)
    yield step("reset to IDLE")
    for g, d in [(1, 0), (0, 0), (0, 0), (0, 0), (0, 1), (0, 0), (0, 0)]:
        yield step("full cycle", g, d)
    for _ in range(1500):
        yield step("1500 random cycles", int(rnd.random() < 0.4), int(rnd.random() < 0.3), rst=int(rnd.random() < 0.005))
