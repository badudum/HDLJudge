CLOCK = None


def vectors():
    for a in range(10):
        for b in range(10):
            for c in range(2):
                s = a + b + c
                yield "all digit pairs", {"a": a, "b": b, "cin": c}, {"sum": s % 10, "cout": int(s >= 10)}
