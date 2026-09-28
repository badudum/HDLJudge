import random

CLOCK = None


def to_gray(b):
    return b ^ (b >> 1)


def from_gray(g):
    b = 0
    while g:
        b ^= g
        g >>= 1
    return b


def vectors():
    rnd = random.Random(12)
    for b in range(256):
        g = rnd.getrandbits(8)
        yield "binary to Gray (all 256 values)", {"bin": b, "gray_in": g}, {"gray": to_gray(b), "bin_out": from_gray(g)}
    for g in range(256):
        b = rnd.getrandbits(8)
        yield "Gray to binary (all 256 values)", {"bin": b, "gray_in": g}, {"gray": to_gray(b), "bin_out": from_gray(g)}
    for _ in range(200):
        b = rnd.getrandbits(8)
        yield "round trip bin -> Gray -> bin", {"bin": b, "gray_in": to_gray(b)}, {"gray": to_gray(b), "bin_out": b}
