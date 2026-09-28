import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(69)
    ent = [dict(v=0, d=0, rd=0, data=0) for _ in range(8)]
    head = tail = count = 0
    out = dict(alloc_ok=0, alloc_tag=None, commit_valid=0, commit_rd=None, commit_data=None, count=0)

    def step(name, av=0, ard=0, cv=0, ctag=0, cdata=0, rst=0):
        nonlocal ent, head, tail, count, out
        if rst:
            ent = [dict(v=0, d=0, rd=0, data=0) for _ in range(8)]
            head = tail = count = 0
            out = dict(alloc_ok=0, alloc_tag=None, commit_valid=0, commit_rd=None, commit_data=None, count=0)
        else:
            o = dict(alloc_ok=0, alloc_tag=None, commit_valid=0, commit_rd=None, commit_data=None)
            full = count == 8
            h = ent[head]
            commit = h["v"] and h["d"]
            if commit:
                o.update(commit_valid=1, commit_rd=h["rd"], commit_data=h["data"])
            if cv:
                ent[ctag]["d"], ent[ctag]["data"] = 1, cdata
            if commit:
                ent[head] = dict(v=0, d=0, rd=0, data=0)
                head = (head + 1) % 8
            alloc = av and not full
            if alloc:
                ent[tail] = dict(v=1, d=0, rd=ard, data=0)
                o.update(alloc_ok=1, alloc_tag=tail)
                tail = (tail + 1) % 8
            count = count - int(bool(commit)) + int(bool(alloc))
            o["count"] = count
            out = o
        return name, {"rst": rst, "alloc_valid": av, "alloc_rd": ard, "complete_valid": cv,
                      "complete_tag": ctag, "complete_data": cdata}, dict(out)

    def pending():
        return [i for i in range(8) if ent[i]["v"] and not ent[i]["d"]]

    yield step("reset", rst=1)
    for rd in (5, 6, 7):
        yield step("allocate in order", 1, rd)
    for tag in (2, 0, 1):
        yield step("in-order commit after out-of-order completion", cv=1, ctag=tag, cdata=0x100 + tag)
    for _ in range(4):
        yield step("in-order commit after out-of-order completion")
    for i in range(9):
        yield step("full ROB rejects allocation", 1, i)
    for _ in range(3000):
        p = pending()
        cv = int(bool(p) and rnd.random() < 0.5)
        yield step("3000 random cycles", int(rnd.random() < 0.6), rnd.getrandbits(5), cv,
                   rnd.choice(p) if cv else rnd.getrandbits(3), rnd.getrandbits(16))
