import random

CLOCK = None


def vectors():
    rnd = random.Random(193)
    st = {"q": 0}

    def step(name, vin, vl=0.8, vh=1.2):
        if vl < 0.3:
            st["q"] = 0
        elif vin > 0.6 * vl:
            st["q"] = 1
        elif vin < 0.4 * vl:
            st["q"] = 0
        return name, {"vin": vin, "vddl": vl, "vddh": vh}, {"vout": vh if (st["q"] and vl >= 0.3) else 0.0}

    for v in (0.0, 0.2, 0.5, 0.8, 0.3, 0.0):
        yield step("switches at the thresholds", v)
    for v in (0.0, 0.4, 0.45, 0.5, 0.4, 0.35, 0.33, 0.31, 0.4):
        yield step("hysteresis band holds", v)
    yield step("isolated when vddl is off", 0.8, 0.8)
    yield step("isolated when vddl is off", 0.8, 0.0)
    yield step("isolated when vddl is off", 0.0, 0.0)
    yield step("isolated when vddl is off", 0.4, 0.8)
    yield step("other supply levels", 0.6, 1.0, 1.8)
    yield step("other supply levels", 0.5, 1.0, 1.8)
    yield step("other supply levels", 0.35, 1.0, 1.8)
    yield step("other supply levels", 0.35, 1.0, 3.3)
    for _ in range(1500):
        vl = rnd.choice([0.8, 0.8, 0.9, 0.6, 0.0, 0.25])
        yield step("1500 random inputs", round(rnd.uniform(0, max(vl, 0.1)), 4), vl, rnd.choice([1.2, 1.8, 3.3]))
