CLOCK = None


def vectors():
    for x in range(256):
        v = x - 256 if x >= 128 else x
        yield "all 256 values", {"x": x}, {"y": abs(v) & 0xFF}
