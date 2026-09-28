import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(25)
    busy, cnt, frame = False, 0, [1] * 10

    def step(name, start=0, data=0, rst=0):
        nonlocal busy, cnt, frame
        if rst:
            busy = False
        elif busy:
            cnt += 1
            if cnt == 40:
                busy = False
        elif start:
            busy, cnt = True, 0
            frame = [0] + [(data >> i) & 1 for i in range(8)] + [1]
        tx = frame[cnt // 4] if busy else 1
        return name, {"rst": rst, "start": start, "data": data}, {"tx": tx, "busy": int(busy)}

    yield step("idle after reset", rst=1)
    for _ in range(8):
        yield step("idle after reset")
    yield step("single frame 0x55", start=1, data=0x55)
    for _ in range(45):
        yield step("single frame 0x55", data=0xFF)
    yield step("start ignored while busy", start=1, data=0x0F)
    for i in range(45):
        yield step("start ignored while busy", start=int(i % 7 == 3), data=0xF0)
    for _ in range(130):
        yield step("back-to-back frames with start held high", start=1, data=0xA3)
    for _ in range(12):
        yield step("reset aborts a frame")
    yield step("reset aborts a frame", rst=1)
    for _ in range(6):
        yield step("reset aborts a frame")
    for _ in range(3000):
        yield step("3000 cycles of random traffic", start=int(rnd.random() < 0.1),
                   data=rnd.getrandbits(8), rst=int(rnd.random() < 0.002))
