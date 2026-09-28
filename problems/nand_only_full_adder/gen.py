CLOCK = None


def vectors():
    for a in (0, 1):
        for b in (0, 1):
            for c in (0, 1):
                s = a + b + c
                yield "truth table", {"a": a, "b": b, "cin": c}, {"sum": s & 1, "cout": s >> 1}
