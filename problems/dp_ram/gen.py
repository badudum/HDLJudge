import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(159)
    mem, ra, rb = {}, None, None

    def step(name, wa=0, aa=0, da=0, wb=0, ab=0, db=0):
        nonlocal ra, rb
        ra, rb = mem.get(aa), mem.get(ab)
        if wb:
            mem[ab] = db
        if wa:
            mem[aa] = da
        return name, {"we_a": wa, "addr_a": aa, "din_a": da, "we_b": wb, "addr_b": ab, "din_b": db}, {"dout_a": ra, "dout_b": rb}

    yield step("port A writes, port B reads", 1, 3, 0x11, 0, 3)
    yield step("port A writes, port B reads", 0, 0, 0, 0, 3)
    yield step("port B writes, port A reads", 0, 9, 0, 1, 9, 0x22)
    yield step("port B writes, port A reads", 0, 9, 0, 0, 0)
    yield step("write collision: A wins", 1, 7, 0xAA, 1, 7, 0xBB)
    yield step("write collision: A wins", 0, 7, 0, 0, 7)
    yield step("read-first on both ports", 1, 7, 0xCC, 0, 7)
    yield step("read-first on both ports", 0, 7, 0, 1, 7, 0xDD)
    yield step("read-first on both ports", 0, 7, 0, 0, 7)
    for a in range(32):
        yield step("fill through both ports", 1, a, a, 1, (a + 16) % 32, 0x80 | a) if a < 16 else step("fill through both ports", 0, a, 0, 0, a)
    for _ in range(2000):
        yield step("2000 random cycles", rnd.getrandbits(1), rnd.getrandbits(5), rnd.getrandbits(8), rnd.getrandbits(1), rnd.choice([rnd.getrandbits(5), 7]), rnd.getrandbits(8))
