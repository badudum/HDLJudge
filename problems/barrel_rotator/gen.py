CLOCK = None


def rot(d, k, right):
    k %= 8
    if right:
        return ((d >> k) | (d << (8 - k))) & 0xFF
    return ((d << k) | (d >> (8 - k))) & 0xFF


def vectors():
    for d in [0x83, 0x01, 0x80, 0xA5]:
        for k in range(8):
            yield "rotate left", {"din": d, "amt": k, "dir": 0}, {"dout": rot(d, k, 0)}
    for d in [0x83, 0x01, 0x80, 0xA5]:
        for k in range(8):
            yield "rotate right", {"din": d, "amt": k, "dir": 1}, {"dout": rot(d, k, 1)}
    for d in range(256):
        yield "amt = 0 passes din through", {"din": d, "amt": 0, "dir": d & 1}, {"dout": d}
    for d in range(256):
        for k in range(8):
            for r in (0, 1):
                yield "all 4096 input combinations", {"din": d, "amt": k, "dir": r}, {"dout": rot(d, k, r)}
