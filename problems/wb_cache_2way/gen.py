import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(171)
    mem = [rnd.getrandbits(8) for _ in range(64)]
    ways = None
    lru = None
    out = {}

    def reset():
        nonlocal ways, lru
        ways = [[{"v": 0, "d": 0, "t": 0, "x": 0} for _ in range(2)] for _ in range(4)]
        lru = [0] * 4
        out.update(hit=0, rdata=None, wb_valid=0, wb_addr=None, wb_data=None)

    reset()

    def step(name, req=0, we=0, a=0, wd=0, rst=0):
        s, t = a & 3, a >> 2
        mrd = mem[a]
        if rst:
            reset()
        elif req:
            w = [k for k in range(2) if ways[s][k]["v"] and ways[s][k]["t"] == t]
            out.update(wb_valid=0, wb_addr=None, wb_data=None)
            if w:
                k = w[0]
                if we:
                    ways[s][k].update(x=wd, d=1)
                out["hit"] = 1
            else:
                k = 0 if not ways[s][0]["v"] else (1 if not ways[s][1]["v"] else lru[s])
                v = ways[s][k]
                if v["v"] and v["d"]:
                    wa = (v["t"] << 2) | s
                    out.update(wb_valid=1, wb_addr=wa, wb_data=v["x"])
                    mem[wa] = v["x"]
                ways[s][k] = {"v": 1, "d": we, "t": t, "x": wd if we else mrd}
                out["hit"] = 0
            lru[s] = 1 - k
            out["rdata"] = None if we else ways[s][k]["x"]
        else:
            out.update(hit=0, rdata=None, wb_valid=0, wb_addr=None, wb_data=None)
        return name, {"rst": rst, "req": req, "we": we, "addr": a, "wdata": wd, "mem_rdata": mrd}, dict(out)

    yield step("fills both ways of a set", rst=1)
    for a in (0x01, 0x05, 0x01, 0x05):
        yield step("fills both ways of a set", 1, 0, a)
    yield step("LRU victim selection", 1, 0, 0x01)
    yield step("LRU victim selection", 1, 0, 0x09)
    yield step("LRU victim selection", 1, 0, 0x01)
    yield step("LRU victim selection", 1, 0, 0x05)
    yield step("dirty eviction writes back", 1, 1, 0x01, 0xD1)
    yield step("dirty eviction writes back", 1, 0, 0x0D)
    yield step("dirty eviction writes back", 1, 0, 0x11)
    yield step("dirty eviction writes back", 1, 0, 0x01)
    yield step("dirty eviction writes back", 0)
    yield step("write miss allocates", 1, 1, 0x22, 0x5A)
    yield step("write miss allocates", 1, 0, 0x22)
    for _ in range(3000):
        a = rnd.choice([rnd.getrandbits(6), rnd.getrandbits(6) & 0x1F, rnd.choice([0x03, 0x07, 0x0B, 0x0F, 0x13])])
        yield step("3000 random accesses (memory model checks writebacks)", int(rnd.random() < 0.85), int(rnd.random() < 0.4), a,
                   rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
