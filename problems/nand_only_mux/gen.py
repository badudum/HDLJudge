CLOCK = None


def vectors():
    for s in (0, 1):
        for a in (0, 1):
            for b in (0, 1):
                yield "truth table", {"a": a, "b": b, "sel": s}, {"y": b if s else a}
