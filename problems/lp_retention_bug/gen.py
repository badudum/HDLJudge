import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(195)
    st = {"c": 0, "sh": 0}

    def step(name, pwr=1, save=0, rest=0, en=0, rst=0):
        if rst:
            st.update(c=0, sh=0)
        else:
            c, sh = st["c"], st["sh"]
            if save and pwr:
                st["sh"] = c
            if not pwr:
                st["c"] = 0
            elif rest:
                st["c"] = sh
            elif en:
                st["c"] = (c + 1) & 0xFF
        return name, {"rst": rst, "pwr_on": pwr, "save": save, "restore": rest, "en": en}, {"count_out": st["c"] if pwr else 0}

    yield step("save, power cycle, restore", rst=1)
    for _ in range(5):
        yield step("save, power cycle, restore", en=1)
    yield step("save, power cycle, restore", save=1)
    for _ in range(3):
        yield step("save, power cycle, restore", pwr=0)
    yield step("save, power cycle, restore", pwr=1)
    yield step("save, power cycle, restore", rest=1)
    yield step("save, power cycle, restore")
    yield step("late save while off is ignored", save=1)
    yield step("late save while off is ignored", pwr=0)
    yield step("late save while off is ignored", pwr=0, save=1)
    yield step("late save while off is ignored", pwr=1)
    yield step("late save while off is ignored", rest=1)
    yield step("late save while off is ignored")
    yield step("restore wins over count", en=1, save=1)
    yield step("restore wins over count", pwr=0, en=1)
    yield step("restore wins over count", pwr=1, en=1, rest=1)
    yield step("restore wins over count", en=1)
    yield step("isolation clamps to 0", pwr=0)
    yield step("isolation clamps to 0", pwr=0, en=1)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.8), int(rnd.random() < 0.1), int(rnd.random() < 0.1), rnd.getrandbits(1),
                   rst=int(rnd.random() < 0.002))
