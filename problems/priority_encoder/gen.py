CLOCK = None


def e(r):
    return {"idx": r.bit_length() - 1 if r else 0, "valid": int(r != 0)}


def vectors():
    yield "no request", {"req": 0}, e(0)
    for i in range(8):
        yield "single request", {"req": 1 << i}, e(1 << i)
    for r in [0x46, 0xFF, 0x81, 0x03, 0x7E, 0x2C]:
        yield "highest wins", {"req": r}, e(r)
    for r in range(256):
        yield "all 256 request patterns", {"req": r}, e(r)
