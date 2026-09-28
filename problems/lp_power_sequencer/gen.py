import random

CLOCK = "clk"
OUT = {"ON": (1, 0, 0, 0, 1, 0), "STOP_CLK": (0, 0, 0, 0, 1, 0), "ISOLATE": (0, 1, 0, 0, 1, 0), "SAVE": (0, 1, 1, 0, 1, 0),
       "PWR_OFF": (0, 1, 0, 0, 0, 0), "OFF": (0, 1, 0, 0, 0, 1), "PWR_ON": (0, 1, 0, 0, 1, 0), "RESTORE": (0, 1, 0, 1, 1, 0),
       "DEISO": (0, 0, 0, 0, 1, 0)}
NAMES = ("clk_en", "iso_en", "save", "restore", "pwr_en", "asleep")


def vectors():
    rnd = random.Random(191)
    st = {"s": "ON"}
    rail = {"hist": [1] * 8, "delay": 3}

    def step(name, sl=0, wk=0, rst=0):
        ack = rail["hist"][-rail["delay"]]
        s = st["s"]
        if rst:
            n = "ON"
        elif s == "ON":
            n = "STOP_CLK" if sl else "ON"
        elif s == "STOP_CLK":
            n = "ISOLATE"
        elif s == "ISOLATE":
            n = "SAVE"
        elif s == "SAVE":
            n = "PWR_OFF"
        elif s == "PWR_OFF":
            n = "OFF" if not ack else "PWR_OFF"
        elif s == "OFF":
            n = "PWR_ON" if wk else "OFF"
        elif s == "PWR_ON":
            n = "RESTORE" if ack else "PWR_ON"
        elif s == "RESTORE":
            n = "DEISO"
        else:
            n = "ON"
        st["s"] = n
        rail["hist"] = rail["hist"][1:] + [OUT[n][4]]
        if rnd.random() < 0.1:
            rail["delay"] = rnd.randint(1, 6)
        return name, {"rst": rst, "sleep_req": sl, "wake_req": wk, "pwr_ack": ack}, dict(zip(NAMES, OUT[n]))

    yield step("power-down sequence", rst=1)
    yield step("power-down sequence")
    yield step("power-down sequence", sl=1)
    for _ in range(10):
        yield step("power-down sequence", wk=0)
    yield step("ignores sleep while off", sl=1)
    yield step("power-up sequence", wk=1)
    for _ in range(12):
        yield step("power-up sequence", sl=0)
    yield step("ignores wake while on", wk=1)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.1), int(rnd.random() < 0.1), rst=int(rnd.random() < 0.002))
