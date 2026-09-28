import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(190)
    st = {"q": 0, "sh": 0}

    def step(name, pwr=1, save=0, rest=0, en=0, d=0, rst=0):
        if rst:
            st.update(q=0, sh=0)
        else:
            q, sh = st["q"], st["sh"]
            if save and pwr:
                st["sh"] = q
            if not pwr:
                st["q"] = 0
            elif rest:
                st["q"] = sh
            elif en:
                st["q"] = d
        return name, {"rst": rst, "pwr_on": pwr, "save": save, "restore": rest, "en": en, "d": d}, {"q_out": st["q"] if pwr else 0}

    yield step("normal register", rst=1)
    yield step("normal register", en=1, d=0x5A)
    yield step("normal register", en=0, d=0x11)
    yield step("save, power off, restore", save=1)
    yield step("save, power off, restore", en=1, d=0x77)
    for _ in range(4):
        yield step("save, power off, restore", pwr=0, en=1, d=0x33)
    yield step("save, power off, restore", pwr=1)
    yield step("save, power off, restore", rest=1, en=1, d=0x44)
    yield step("save, power off, restore")
    for _ in range(3):
        yield step("state is lost without retention", pwr=0)
    yield step("state is lost without retention", pwr=1)
    yield step("save is ignored while off", pwr=0, save=1)
    yield step("save is ignored while off", pwr=1, rest=1)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.8), int(rnd.random() < 0.1), int(rnd.random() < 0.1), rnd.getrandbits(1),
                   rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
