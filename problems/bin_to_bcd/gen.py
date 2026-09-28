CLOCK = None


def e(v):
    return {"bcd": ((v // 100) << 8) | (((v // 10) % 10) << 4) | (v % 10)}


def vectors():
    for v in range(10):
        yield "small values 0-9", {"bin": v}, e(v)
    for v in [9, 10, 19, 20, 42, 99, 100, 101, 109, 110, 199, 200, 249, 250, 255]:
        yield "decade boundaries", {"bin": v}, e(v)
    for v in range(256):
        yield "all 256 values", {"bin": v}, e(v)
