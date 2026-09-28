CLOCK = None


def g(n):
    return n ^ (n >> 1)


def vectors():
    for n in range(256):
        yield "full sequence", {"g": g(n)}, {"gn": g((n + 1) % 256)}
