import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(237)
    st = {"cap": 0, "upd": 0}

    def step(name, cap=0, sh=0, up=0, mode=0, si=0, din=0, rst=0):
        if rst:
            st.update(cap=0, upd=0)
        elif cap:
            st["cap"] = din
        elif sh:
            st["cap"] = ((st["cap"] << 1) | si) & 0xF
        elif up:
            st["upd"] = st["cap"]
        dout = st["upd"] if mode else din
        return name, {"rst": rst, "capture_dr": cap, "shift_dr": sh, "update_dr": up, "mode": mode, "scan_in": si, "data_in": din}, \
            {"data_out": dout, "scan_out": (st["cap"] >> 3) & 1}

    yield step("capture pins and shift out", rst=1)
    yield step("capture pins and shift out", cap=1, din=0b1010)
    for _ in range(4):
        yield step("capture pins and shift out", sh=1, din=0b1111)
    for b in (0, 1, 1, 0):
        yield step("shift in, update, drive pins", sh=1, si=b, din=0b1001)
    yield step("shift in, update, drive pins", up=1, din=0b1001)
    yield step("shift in, update, drive pins", mode=1, din=0b1001)
    yield step("normal mode passes pins through", mode=0, din=0b0101)
    for _ in range(3000):
        r = rnd.random()
        yield step("3000 random cycles", cap=int(r < 0.1), sh=int(0.1 <= r < 0.6), up=int(0.6 <= r < 0.7), mode=rnd.getrandbits(1),
                   si=rnd.getrandbits(1), din=rnd.getrandbits(4), rst=int(rnd.random() < 0.002))
