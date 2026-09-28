import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(168)
    st = dict(out=0, dir=0, s1=0, s2=0, s3=0, rise=0)

    def step(name, we=0, addr=0, wd=0, gin=0, rst=0):
        s = st
        if rst:
            for k in s:
                s[k] = 0
        else:
            rise = s["s2"] & ~s["s3"] & 0xFF
            clr = wd if (we and addr == 3) else 0
            s["rise"] = (s["rise"] & ~clr & 0xFF) | rise
            if we and addr == 0:
                s["out"] = wd
            if we and addr == 1:
                s["dir"] = wd
            s["s3"], s["s2"], s["s1"] = s["s2"], s["s1"], gin
        rd = [s["out"], s["dir"], s["s2"], s["rise"]][addr]
        return name, {"rst": rst, "we": we, "addr": addr, "wdata": wd, "gpio_in": gin}, {"rdata": rd, "gpio_out": s["out"], "gpio_oe": s["dir"]}

    yield step("OUT and DIR registers", rst=1)
    yield step("OUT and DIR registers", 1, 0, 0xA5)
    yield step("OUT and DIR registers", 0, 0)
    yield step("OUT and DIR registers", 1, 1, 0x0F)
    yield step("OUT and DIR registers", 0, 1)
    yield step("IN is read-only", 1, 2, 0xFF)
    yield step("IN is read-only", 0, 2)
    for g in (0x3C, 0x3C, 0x3C, 0x00, 0x00, 0x00):
        yield step("input synchronizer latency", 0, 2, 0, g)
    for g in (0x08, 0x00, 0x00, 0x00, 0x00):
        yield step("sticky rise flags, write-1-to-clear", 0, 3, 0, g)
    yield step("sticky rise flags, write-1-to-clear", 1, 3, 0x08)
    yield step("sticky rise flags, write-1-to-clear", 0, 3)
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.3), rnd.getrandbits(2), rnd.getrandbits(8),
                   rnd.getrandbits(8) if rnd.random() < 0.3 else 0, rst=int(rnd.random() < 0.003))
