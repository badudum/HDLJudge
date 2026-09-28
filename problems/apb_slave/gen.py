import random

CLOCK = "pclk"
ID = 0xA9B00001


def vectors():
    rnd = random.Random(169)
    st = {"ctrl": 0, "data": 0, "cnt": 0}

    def reg(a):
        return {0: st["ctrl"], 4: st["data"], 8: ID, 12: st["cnt"]}.get(a, 0)

    def err(a, w):
        return int((a & 3) != 0 or a > 12 or (w and a in (8, 12)))

    def cyc(name, sel, en, w, a, wd=0, strb=0xF, rstn=1):
        if not rstn:
            st.update(ctrl=0, data=0, cnt=0)
        elif sel and en and w and not err(a, 1):
            key = "ctrl" if a == 0 else "data"
            m = 0
            for i in range(4):
                if (strb >> i) & 1:
                    m |= 0xFF << (8 * i)
            st[key] = (st[key] & ~m) | (wd & m)
            st["cnt"] = (st["cnt"] + 1) & 0xFFFFFFFF
        rd = reg(a) if (sel and not w and (a & 3) == 0) else 0
        return name, {"presetn": rstn, "psel": sel, "penable": en, "pwrite": w, "paddr": a, "pwdata": wd, "pstrb": strb}, \
            {"prdata": rd, "pready": 1, "pslverr": err(a, w) if (sel and en) else 0}

    def xfer(name, w, a, wd=0, strb=0xF):
        yield cyc(name, 1, 0, w, a, wd, strb)
        yield cyc(name, 1, 1, w, a, wd, strb)

    yield cyc("write and read back", 0, 0, 0, 0, rstn=0)
    for step in (xfer("write and read back", 1, 4, 0x12345678), xfer("write and read back", 0, 4),
                 xfer("write and read back", 1, 0, 0xCAFEF00D), xfer("write and read back", 0, 0),
                 xfer("read-only ID and write counter", 0, 8), xfer("read-only ID and write counter", 0, 12)):
        yield from step
    yield cyc("idle bus", 0, 0, 0, 4)
    yield from xfer("byte strobes", 1, 4, 0xFFFFFFFF, 0b0101)
    yield from xfer("byte strobes", 0, 4)
    yield from xfer("byte strobes", 1, 4, 0, 0b1000)
    yield from xfer("byte strobes", 0, 4)
    for a, w in ((8, 1), (12, 1), (0x10, 0), (0x10, 1), (5, 0), (6, 1), (0xFC, 1)):
        yield from xfer("error responses", w, a, 0xDEADBEEF)
    yield from xfer("error responses", 0, 12)
    for _ in range(1200):
        if rnd.random() < 0.2:
            yield cyc("1200 random transfers", 0, 0, rnd.getrandbits(1), rnd.getrandbits(8), rnd.getrandbits(32), rnd.getrandbits(4),
                      rstn=int(rnd.random() > 0.01))
        a = rnd.choice([0, 4, 8, 12, rnd.getrandbits(8)])
        yield from xfer("1200 random transfers", rnd.getrandbits(1), a, rnd.getrandbits(32), rnd.getrandbits(4))
