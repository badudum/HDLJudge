CLOCK = None
PARAMS = {"N": 5}


def vectors():
    for s in range(32):
        yield "every output line", {"sel": s, "en": 1}, {"y": 1 << s}
    for s in range(32):
        yield "disabled: all outputs low", {"sel": s, "en": 0}, {"y": 0}
