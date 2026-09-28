import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(157)
    t = [0, 0, 0, 0]

    def step(name, tick=0, load=0, ld=(0, 0, 0, 0), rst=0):
        nonlocal t
        if rst:
            t = [0, 0, 0, 0]
        elif load:
            t = list(ld)
        elif tick:
            t[0] += 1
            if t[0] == 1000:
                t[0] = 0; t[1] += 1
                if t[1] == 60:
                    t[1] = 0; t[2] += 1
                    if t[2] == 60:
                        t[2] = 0; t[3] = (t[3] + 1) % 24
        return name, {"rst": rst, "tick_ms": tick, "load": load, "ld_ms": ld[0], "ld_sec": ld[1], "ld_min": ld[2], "ld_hr": ld[3]}, \
            {"ms": t[0], "sec": t[1], "min": t[2], "hr": t[3]}

    yield step("counting milliseconds", rst=1)
    for i in range(20):
        yield step("counting milliseconds", tick=int(i % 3 != 2))
    yield step("rollover of seconds", load=1, ld=(998, 0, 0, 0))
    for _ in range(3):
        yield step("rollover of seconds", tick=1)
    yield step("rollover of minutes and hours", load=1, ld=(999, 59, 59, 5))
    yield step("rollover of minutes and hours", tick=1)
    yield step("rollover of the day", load=1, ld=(999, 59, 59, 23))
    yield step("rollover of the day", tick=1)
    yield step("rollover of the day", tick=1)
    yield step("load", load=1, tick=1, ld=(789, 56, 34, 12))
    for _ in range(1500):
        if rnd.random() < 0.05:
            ld = (rnd.choice([rnd.randrange(1000), 999]), rnd.choice([rnd.randrange(60), 59]), rnd.choice([rnd.randrange(60), 59]), rnd.choice([rnd.randrange(24), 23]))
            yield step("1500 random cycles", load=1, ld=ld)
        else:
            yield step("1500 random cycles", tick=int(rnd.random() < 0.8), rst=int(rnd.random() < 0.002))
