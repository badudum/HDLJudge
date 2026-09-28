import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(160)
    cnt, acc, ov, od = 0, 0, 0, 0

    def step(name, iv=0, d=0, ordy=0, rst=0):
        nonlocal cnt, acc, ov, od
        if rst:
            cnt, acc, ov = 0, 0, 0
        else:
            irdy = (not ov) or ordy
            if iv and irdy:
                if cnt == 3:
                    od, ov, cnt = (d << 24) | acc, 1, 0
                    acc = 0
                else:
                    acc |= d << (8 * cnt)
                    cnt += 1
                    if ov and ordy:
                        ov = 0
            elif ov and ordy:
                ov = 0
        return name, {"rst": rst, "in_valid": iv, "in_data": d, "out_ready": ordy}, \
            {"in_ready": int((not ov) or ordy), "out_valid": ov, "out_data": od if ov else None}

    yield step("packs four bytes little-endian", rst=1)
    for b in (0x11, 0x22, 0x33, 0x44):
        yield step("packs four bytes little-endian", 1, b, 0)
    yield step("packs four bytes little-endian", 0, 0, 1)
    for b in (0x55, 0x66, 0x77, 0x88, 0x99):
        yield step("backpressure holds the word", 1, b, 0)
    for _ in range(3):
        yield step("backpressure holds the word", 1, 0xEE, 0)
    yield step("backpressure holds the word", 0, 0, 1)
    for i in range(24):
        yield step("streaming at full throughput", 1, i, 1)
    for _ in range(3000):
        yield step("3000 cycles of random traffic", int(rnd.random() < 0.75), rnd.getrandbits(8), int(rnd.random() < 0.6), rst=int(rnd.random() < 0.002))
