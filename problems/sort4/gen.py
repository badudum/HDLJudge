import random

CLOCK = None


def v(a):
    s = sorted(a)
    return {"in0": a[0], "in1": a[1], "in2": a[2], "in3": a[3]}, {"out0": s[0], "out1": s[1], "out2": s[2], "out3": s[3]}


def vectors():
    rnd = random.Random(217)
    for a in ([3, 1, 4, 1], [0, 0, 0, 0], [255, 0, 255, 0], [4, 3, 2, 1], [1, 2, 3, 4]):
        yield ("sorts",) + v(a)
    import itertools
    for p in itertools.permutations([10, 20, 30, 40]):
        yield ("all permutations",) + v(list(p))
    for _ in range(5000):
        yield ("5000 random",) + v([rnd.choice([rnd.getrandbits(8), rnd.getrandbits(2)]) for _ in range(4)])
