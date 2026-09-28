CLOCK = None


def vectors():
    for x in [3] + list(range(256)):
        yield "all 256 values", {"x": x}, {"m7": 7 * x, "m10": 10 * x, "m255": 255 * x}
