import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(170)
    valid, tag, data = [0] * 8, [0] * 8, [0] * 8
    st = {"hit": 0, "rdata": None, "hits": 0, "misses": 0}

    def step(name, op="", a=0, wd=0, fd=0, rst=0):
        i, t = a & 7, a >> 3
        if rst:
            for k in range(8):
                valid[k] = 0
            st.update(hit=0, rdata=None, hits=0, misses=0)
        else:
            h = int(valid[i] and tag[i] == t)
            if op in ("rd", "wr"):
                st["hit"], st["rdata"] = h, (data[i] if h else None)
                if op == "rd":
                    st["hits" if h else "misses"] += 1
                    st["hits"] &= 0xFF
                    st["misses"] &= 0xFF
                if op == "wr" and h:
                    data[i] = wd
            else:
                st["hit"], st["rdata"] = 0, None
                if op == "fill":
                    valid[i], tag[i], data[i] = 1, t, fd
                elif op == "inv":
                    for k in range(8):
                        valid[k] = 0
        ins = {"rst": rst, "rd": int(op == "rd"), "wr": int(op == "wr"), "fill": int(op == "fill"), "inv": int(op == "inv"),
               "addr": a, "wdata": wd, "fill_data": fd}
        return name, ins, {"hit": st["hit"], "rdata": st["rdata"] if st["hit"] and op == "rd" else None, "hits": st["hits"], "misses": st["misses"]}

    yield step("cold miss then fill then hit", rst=1)
    yield step("cold miss then fill then hit", "rd", 0x2A)
    yield step("cold miss then fill then hit", "fill", 0x2A, fd=0x77)
    yield step("cold miss then fill then hit", "rd", 0x2A)
    yield step("cold miss then fill then hit", "", 0x2A)
    yield step("conflict misses", "fill", 0x05, fd=0x11)
    yield step("conflict misses", "rd", 0x0D)
    yield step("conflict misses", "fill", 0x0D, fd=0x22)
    yield step("conflict misses", "rd", 0x05)
    yield step("conflict misses", "rd", 0x0D)
    yield step("write-through, no allocate", "wr", 0x44, wd=0x99)
    yield step("write-through, no allocate", "rd", 0x44)
    yield step("write-through, no allocate", "wr", 0x0D, wd=0x33)
    yield step("write-through, no allocate", "rd", 0x0D)
    yield step("invalidate all", "inv")
    yield step("invalidate all", "rd", 0x0D)
    yield step("invalidate all", "rd", 0x2A)
    mem = [rnd.getrandbits(8) for _ in range(256)]
    for _ in range(3000):
        r = rnd.random()
        a = rnd.choice([rnd.getrandbits(8), rnd.getrandbits(4)])
        if r < 0.45:
            yield step("3000 random operations", "rd", a)
        elif r < 0.65:
            wd = rnd.getrandbits(8)
            mem[a] = wd
            yield step("3000 random operations", "wr", a, wd=wd)
        elif r < 0.93:
            yield step("3000 random operations", "fill", a, fd=mem[a])
        elif r < 0.95:
            yield step("3000 random operations", "inv")
        else:
            yield step("3000 random operations", "", a, rst=int(rnd.random() < 0.1))
