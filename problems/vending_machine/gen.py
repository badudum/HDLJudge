import random

CLOCK = "clk"
VALUE = [0, 5, 10, 25]


def vectors():
    rnd = random.Random(24)
    credit = disp = chg = 0

    def step(name, coin, rst=0):
        nonlocal credit, disp, chg
        if rst:
            credit = disp = chg = 0
        else:
            total = credit + VALUE[coin]
            if total >= 30:
                credit, disp, chg = 0, 1, total - 30
            else:
                credit, disp, chg = total, 0, 0
        return name, {"rst": rst, "coin": coin}, {"dispense": disp, "change": chg, "credit": credit}

    yield step("exact payment 25 + 5", 0, rst=1)
    for c in [3, 1, 0]:
        yield step("exact payment 25 + 5", c)
    for c in [2, 2, 3, 0]:
        yield step("change returned 10 + 10 + 25", c)
    for c in [3, 3, 0]:
        yield step("maximum change 25 + 25", c)
    for c in [1, 1, 1, 1, 1, 1, 0]:
        yield step("six nickels", c)
    for c in [0, 0, 0, 2, 0, 0, 0]:
        yield step("no coin keeps the credit", c)
    for c in [3]:
        yield step("reset clears the credit", c)
    yield step("reset clears the credit", 2, rst=1)
    yield step("reset clears the credit", 0)
    for _ in range(1500):
        yield step("1500 random coin sequences", rnd.choice([0, 0, 1, 2, 3]), rst=int(rnd.random() < 0.005))
