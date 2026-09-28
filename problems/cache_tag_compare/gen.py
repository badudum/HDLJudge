import random

CLOCK = None


def e(tag, tags, valid):
    oh = sum(1 << i for i in range(4) if valid >> i & 1 and tags[i] == tag)
    return {"hit": int(oh != 0), "hit_way": (oh & -oh).bit_length() - 1 if oh else 0,
            "hit_onehot": oh, "multi_hit": int(oh & (oh - 1) != 0)}


def pack(t):
    return sum(x << (20 * i) for i, x in enumerate(t))


def vectors():
    rnd = random.Random(60)
    for w in range(4):
        tags = [rnd.getrandbits(20) for _ in range(4)]
        yield "hits in every way", {"tag": tags[w], "way_tags": pack(tags), "way_valid": 15}, e(tags[w], tags, 15)
    for w in range(4):
        tags = [rnd.getrandbits(20) for _ in range(4)]
        v = 15 & ~(1 << w)
        yield "invalid ways never hit", {"tag": tags[w], "way_tags": pack(tags), "way_valid": v}, e(tags[w], tags, v)
    for v in [0b1010, 0b1111, 0b0110]:
        tags = [0xABCDE] * 4
        yield "multi-hit detection", {"tag": 0xABCDE, "way_tags": pack(tags), "way_valid": v}, e(0xABCDE, tags, v)
    for _ in range(3000):
        tags = [rnd.getrandbits(20) for _ in range(4)]
        t = rnd.choice(tags + [rnd.getrandbits(20)])
        if rnd.random() < 0.1:
            tags[rnd.getrandbits(2)] = t
        v = rnd.getrandbits(4)
        yield "3000 random lookups", {"tag": t, "way_tags": pack(tags), "way_valid": v}, e(t, tags, v)
