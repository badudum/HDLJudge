import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(71)
    st, beat, ml, vl = "IDLE", 0, 0, 0

    def outs():
        if st == "WB":
            return {"mem_req": 1, "mem_we": 1, "mem_addr": vl * 4 + beat, "done": 0}
        if st == "RF":
            return {"mem_req": 1, "mem_we": 0, "mem_addr": ml * 4 + beat, "done": 0}
        return {"mem_req": 0, "mem_we": None, "mem_addr": None, "done": int(st == "DONE")}

    def step(name, miss=0, dirty=0, m=0, v=0, ack=0, rst=0):
        nonlocal st, beat, ml, vl
        if rst:
            st = "IDLE"
        elif st == "IDLE":
            if miss:
                ml, vl, beat = m, v, 0
                st = "WB" if dirty else "RF"
        elif st in ("WB", "RF"):
            if ack:
                if beat == 3:
                    beat = 0
                    st = "RF" if st == "WB" else "DONE"
                else:
                    beat += 1
        elif st == "DONE":
            st = "IDLE"
        return name, {"rst": rst, "miss": miss, "dirty": dirty, "miss_line": m, "victim_line": v, "mem_ack": ack}, outs()

    yield step("reset", rst=1)
    yield step("clean miss: refill only", 1, 0, 0x12, 0x34, 0)
    for _ in range(7):
        yield step("clean miss: refill only", 0, 0, 0xFF, 0xFF, 1)
    yield step("dirty miss: write back, then refill", 1, 1, 0x55, 0xAA, 0)
    for _ in range(12):
        yield step("dirty miss: write back, then refill", 1, 1, 0x01, 0x02, 1)
    yield step("slow memory with wait states", 1, 1, 0x70, 0x71, 0)
    for i in range(30):
        yield step("slow memory with wait states", 0, 0, 0, 0, int(i % 3 == 2))
    for _ in range(3000):
        yield step("3000 random cycles", int(rnd.random() < 0.3), rnd.getrandbits(1), rnd.getrandbits(8), rnd.getrandbits(8),
                   int(rnd.random() < 0.6), rst=int(rnd.random() < 0.002))
