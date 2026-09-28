import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(62)
    cnt = [0, 0, 0, 0]
    acc = 0

    def step(name, issue=0, fu=0, lat=0, rst=0):
        nonlocal cnt, acc
        if rst:
            cnt, acc = [0, 0, 0, 0], 0
        else:
            ok = issue and cnt[fu] == 0 and lat != 0
            cnt = [max(0, c - 1) for c in cnt]
            if ok:
                cnt[fu] = lat
            acc = int(bool(ok))
        return name, {"rst": rst, "issue": issue, "fu": fu, "latency": lat}, \
            {"busy": sum(1 << i for i in range(4) if cnt[i]), "accepted": acc}

    yield step("issue and count down", rst=1)
    yield step("issue and count down", 1, 2, 3)
    for _ in range(4):
        yield step("issue and count down")
    yield step("structural hazard: busy unit rejects", 1, 2, 3)
    yield step("structural hazard: busy unit rejects", 1, 2, 2)
    yield step("structural hazard: busy unit rejects", 1, 2, 5)
    yield step("structural hazard: busy unit rejects", 0)
    yield step("structural hazard: busy unit rejects", 0)
    yield step("structural hazard: busy unit rejects", 1, 2, 2)
    yield step("independent units", 1, 0, 7)
    yield step("independent units", 1, 1, 1)
    yield step("independent units", 1, 3, 4)
    for _ in range(8):
        yield step("independent units")
    yield step("latency 0 is rejected", 1, 1, 0)
    for _ in range(2500):
        yield step("2500 random issues", int(rnd.random() < 0.5), rnd.getrandbits(2), rnd.getrandbits(3), rst=int(rnd.random() < 0.003))
