import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(197)
    st = {}

    def reset():
        st.update(v=[[0, 0] for _ in range(4)], t=[[0, 0] for _ in range(4)], mru=[0] * 4, pred=0, fh=0, sh=0, ms=0, reads=0)

    reset()

    def step(name, req=0, a=0, rst=0):
        if rst:
            reset()
        elif req:
            s, t = a & 3, a >> 2
            p = st["mru"][s]
            hit = [st["v"][s][w] and st["t"][s][w] == t for w in (0, 1)]
            st["pred"] = p
            st["fh"] = st["sh"] = st["ms"] = 0
            if hit[p]:
                st["fh"], w, r = 1, p, 1
            elif hit[1 - p]:
                st["sh"], w, r = 1, 1 - p, 2
            else:
                st["ms"], r = 1, 2
                w = 0 if not st["v"][s][0] else (1 if not st["v"][s][1] else 1 - p)
                st["v"][s][w], st["t"][s][w] = 1, t
            st["mru"][s] = w
            st["reads"] = (st["reads"] + r) & 0xFFFF
        else:
            st["fh"] = st["sh"] = st["ms"] = 0
        return name, {"rst": rst, "req": req, "addr": a}, {"pred": st["pred"], "fast_hit": st["fh"], "slow_hit": st["sh"], "miss": st["ms"], "tag_reads": st["reads"]}

    yield step("predicted way hits", rst=1)
    for a in (0x05, 0x05, 0x05):
        yield step("predicted way hits", 1, a)
    for a in (0x09, 0x05, 0x09, 0x05):
        yield step("mispredict costs a second probe", 1, a)
    for a in (0x0D, 0x0D, 0x09):
        yield step("replacement of the non-MRU way", 1, a)
    for _ in range(3000):
        a = rnd.choice([rnd.getrandbits(6), rnd.choice([0x01, 0x05, 0x09, 0x0D, 0x02, 0x06])])
        yield step("3000 random accesses", int(rnd.random() < 0.8), a, rst=int(rnd.random() < 0.002))
