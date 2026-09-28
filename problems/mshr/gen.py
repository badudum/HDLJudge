import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(70)
    v = [0] * 4
    a = [0] * 4
    out = {}

    def step(name, mv=0, ma=0, rv=0, rid=0, rst=0):
        nonlocal v, a, out
        o = dict(mem_req=0, mem_id=None, mem_addr=None, merged=0, merge_id=None, stall=0)
        if rst:
            v = [0] * 4
        else:
            if rv:
                v[rid] = 0
            if mv:
                hit = next((i for i in range(4) if v[i] and a[i] == ma), None)
                if hit is not None:
                    o.update(merged=1, merge_id=hit)
                else:
                    free = next((i for i in range(4) if not v[i]), None)
                    if free is None:
                        o["stall"] = 1
                    else:
                        v[free], a[free] = 1, ma
                        o.update(mem_req=1, mem_id=free, mem_addr=ma)
        o["valid_mask"] = sum(v[i] << i for i in range(4))
        out = o
        return name, {"rst": rst, "miss_valid": mv, "miss_addr": ma, "resp_valid": rv, "resp_id": rid}, dict(out)

    yield step("reset", rst=1)
    yield step("primary miss", 1, 0x40)
    yield step("secondary miss merges", 1, 0x40)
    for addr in (0x80, 0x10, 0x20):
        yield step("fill all entries", 1, addr)
    yield step("full: stall", 1, 0x99)
    yield step("full: merge still works", 1, 0x10)
    yield step("response frees an entry first", 1, 0x99, 1, 2)
    yield step("response frees an entry first", 0, 0, 1, 0)
    yield step("response frees an entry first", 1, 0x40)
    for _ in range(3000):
        valid_ids = [i for i in range(4) if v[i]]
        rv = int(bool(valid_ids) and rnd.random() < 0.3)
        yield step("3000 random misses and responses", int(rnd.random() < 0.6), rnd.choice([rnd.getrandbits(8), rnd.getrandbits(3)]),
                   rv, rnd.choice(valid_ids) if rv else 0, rst=int(rnd.random() < 0.002))
