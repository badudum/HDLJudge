import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(22)
    cnt = 0

    def step(name, duty, rst=0):
        nonlocal cnt
        cnt = 0 if rst else (cnt + 1) & 0xFF
        return name, {"rst": rst, "duty": duty}, {"pwm_out": int(cnt < duty)}

    yield step("reset starts the counter at 0", 5, rst=1)
    for _ in range(10):
        yield step("reset starts the counter at 0", 5)
    yield step("duty = 64 (25 %)", 64, rst=1)
    for _ in range(512):
        yield step("duty = 64 (25 %)", 64)
    for _ in range(300):
        yield step("duty = 0 (always low)", 0)
    for _ in range(300):
        yield step("duty = 255 (high 255 of 256 cycles)", 255)
    for _ in range(100):
        yield step("duty changes mid-period", 200)
    for _ in range(200):
        yield step("duty changes mid-period", 10)
    d = 0
    for i in range(2000):
        if i % 97 == 0:
            d = rnd.getrandbits(8)
        yield step("2000 cycles with random duty and resets", d, rst=int(rnd.random() < 0.003))
