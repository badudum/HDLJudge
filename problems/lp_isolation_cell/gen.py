import random

CLOCK = None


def e(iso, d, v, r):
    return {"ao_data": 0 if iso else d, "ao_valid": 0 if iso else v, "ao_req_n": 1 if iso else r}


def vectors():
    rnd = random.Random(186)
    for d, v, r in [(0xA5, 1, 0), (0x00, 0, 1), (0xFF, 1, 1), (0x3C, 0, 0)]:
        yield "pass-through when not isolated", {"iso_en": 0, "pd_data": d, "pd_valid": v, "pd_req_n": r}, e(0, d, v, r)
    for d, v, r in [(0xA5, 1, 0), (0x00, 0, 1), (0xFF, 1, 1), (0x3C, 0, 0)]:
        yield "clamped to inactive values", {"iso_en": 1, "pd_data": d, "pd_valid": v, "pd_req_n": r}, e(1, d, v, r)
    for _ in range(500):
        iso, d, v, r = rnd.getrandbits(1), rnd.getrandbits(8), rnd.getrandbits(1), rnd.getrandbits(1)
        yield "500 random", {"iso_en": iso, "pd_data": d, "pd_valid": v, "pd_req_n": r}, e(iso, d, v, r)
