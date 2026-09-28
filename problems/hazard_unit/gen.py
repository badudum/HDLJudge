import random

CLOCK = None


def e(i):
    lu = bool(i["ex_mem_read"] and i["ex_rd"] != 0 and
              ((i["id_uses_rs1"] and i["ex_rd"] == i["id_rs1"]) or (i["id_uses_rs2"] and i["ex_rd"] == i["id_rs2"])))
    br = bool(i["ex_branch_taken"])
    return {"stall": int(lu and not br), "id_ex_bubble": int(lu or br), "if_id_flush": int(br)}


def mk(rs1, rs2, u1, u2, rd, mr, br):
    return {"id_rs1": rs1, "id_rs2": rs2, "id_uses_rs1": u1, "id_uses_rs2": u2,
            "ex_rd": rd, "ex_mem_read": mr, "ex_branch_taken": br}


def vectors():
    rnd = random.Random(54)
    for i in [mk(5, 7, 1, 1, 5, 1, 0), mk(7, 5, 1, 1, 5, 1, 0), mk(5, 5, 1, 1, 5, 1, 0)]:
        yield "load-use stall", i, e(i)
    for i in [mk(0, 3, 1, 1, 0, 1, 0), mk(5, 7, 1, 1, 5, 0, 0), mk(5, 7, 0, 1, 5, 1, 0), mk(7, 5, 1, 0, 5, 1, 0), mk(1, 2, 1, 1, 3, 1, 0)]:
        yield "no hazard: x0, non-load, unused operand, different register", i, e(i)
    for i in [mk(5, 7, 1, 1, 5, 1, 1), mk(1, 2, 1, 1, 3, 0, 1)]:
        yield "taken branch squashes and wins over stall", i, e(i)
    for _ in range(3000):
        rd = rnd.choice([0, rnd.getrandbits(5), 5])
        i = mk(rnd.choice([5, rnd.getrandbits(5)]), rnd.choice([5, rnd.getrandbits(5)]), rnd.getrandbits(1),
               rnd.getrandbits(1), rd, rnd.getrandbits(1), int(rnd.random() < 0.2))
        yield "3000 random pipeline states", i, e(i)
