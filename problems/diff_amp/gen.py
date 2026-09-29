import random

CLOCK = "clk"
PARAMS = {"GAIN": "4.0", "VSAT": "2.0"}
GAIN = 4.0
VSAT = 2.0


def vectors():
    rnd = random.Random(13)

    def step(name, vp, vn):
        raw = GAIN * (vp - vn)
        vout = max(-VSAT, min(VSAT, raw))
        return name, {"vp": vp, "vn": vn}, {"vout": vout}

    # small signal, well inside the rails
    for vp, vn in [(0.0, 0.0), (0.1, 0.0), (0.0, 0.1), (0.2, -0.1), (-0.05, 0.05)]:
        yield step("small signal, no clipping", vp, vn)

    # exactly at the rails and just past them
    yield step("right at the positive rail", VSAT / GAIN, 0.0)
    yield step("just past the positive rail", VSAT / GAIN + 0.01, 0.0)
    yield step("right at the negative rail", -VSAT / GAIN, 0.0)
    yield step("just past the negative rail", -VSAT / GAIN - 0.01, 0.0)

    # large swings, well past saturation both ways
    for vp, vn in [(5.0, 0.0), (0.0, 5.0), (-5.0, 5.0), (5.0, -5.0), (3.0, -3.0)]:
        yield step("large signal, saturates", vp, vn)

    # 400 random differential inputs spanning small and large amplitudes
    for _ in range(400):
        scale = rnd.choice([0.05, 0.2, 1.0, 3.0])
        vp = rnd.uniform(-scale, scale)
        vn = rnd.uniform(-scale, scale)
        yield step("400 random differential inputs", vp, vn)
