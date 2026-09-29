import random

CLOCK = "clk"

# state encoding: 0=I 1=S 2=E 3=M


def vectors():
    rnd = random.Random(7)
    state = 0

    def step(name, rst=0, pr_rd=0, pr_wr=0, bus_rd=0, bus_rdx=0, shared_in=0):
        nonlocal state
        wb = 0
        if rst:
            state = 0
        elif pr_rd:
            if state == 0:
                state = 1 if shared_in else 2
        elif pr_wr:
            state = 3
        elif bus_rd:
            if state == 3:
                wb = 1
                state = 1
            elif state == 2:
                state = 1
        elif bus_rdx:
            if state == 3:
                wb = 1
            state = 0
        return (name,
                {"rst": rst, "pr_rd": pr_rd, "pr_wr": pr_wr, "bus_rd": bus_rd, "bus_rdx": bus_rdx, "shared_in": shared_in},
                {"state": state, "wb": wb})

    yield step("reset goes to Invalid", rst=1)

    # I -> E (no one else has it) and I -> S (someone else has it), each followed by a read hit
    yield step("Invalid + local read, not shared -> Exclusive", pr_rd=1, shared_in=0)
    yield step("Exclusive + local read -> stays Exclusive", pr_rd=1)
    yield step("back to Invalid", rst=1)
    yield step("Invalid + local read, shared -> Shared", pr_rd=1, shared_in=1)
    yield step("Shared + local read -> stays Shared", pr_rd=1)

    # I -> M directly on a local write
    yield step("back to Invalid (2)", rst=1)
    yield step("Invalid + local write -> Modified", pr_wr=1)
    yield step("Modified + local read -> stays Modified", pr_rd=1)
    yield step("Modified + local write -> stays Modified", pr_wr=1)

    # Shared + local write -> Modified
    yield step("back to Invalid (3)", rst=1)
    yield step("get to Shared", pr_rd=1, shared_in=1)
    yield step("Shared + local write -> Modified", pr_wr=1)

    # Exclusive + bus_rd -> Shared, no writeback
    yield step("back to Invalid (4)", rst=1)
    yield step("get to Exclusive", pr_rd=1, shared_in=0)
    yield step("Exclusive + bus_rd -> Shared, no writeback", bus_rd=1)

    # Modified + bus_rd -> Shared, with writeback
    yield step("back to Invalid (5)", rst=1)
    yield step("get to Modified", pr_wr=1)
    yield step("Modified + bus_rd -> Shared, writeback asserted", bus_rd=1)

    # Modified + bus_rdx -> Invalid, with writeback
    yield step("back to Modified", pr_wr=1)
    yield step("Modified + bus_rdx -> Invalid, writeback asserted", bus_rdx=1)

    # Shared + bus_rdx -> Invalid, no writeback
    yield step("back to Invalid (6)", rst=1)
    yield step("get to Shared (2)", pr_rd=1, shared_in=1)
    yield step("Shared + bus_rdx -> Invalid, no writeback", bus_rdx=1)

    # Shared + bus_rd -> stays Shared
    yield step("get to Shared (3)", pr_rd=1, shared_in=1)
    yield step("Shared + bus_rd -> stays Shared", bus_rd=1)

    # Invalid ignores bus snoops
    yield step("back to Invalid (7)", rst=1)
    yield step("Invalid + bus_rd -> stays Invalid", bus_rd=1)
    yield step("Invalid + bus_rdx -> stays Invalid", bus_rdx=1)

    # long randomized run, one-hot control signal each cycle
    yield step("reset before random run", rst=1)
    for _ in range(400):
        r = rnd.random()
        if r < 0.02:
            yield step("400 random cycles", rst=1)
        else:
            pick = rnd.choice(["pr_rd", "pr_wr", "bus_rd", "bus_rdx", "none"])
            yield step("400 random cycles",
                        pr_rd=int(pick == "pr_rd"), pr_wr=int(pick == "pr_wr"),
                        bus_rd=int(pick == "bus_rd"), bus_rdx=int(pick == "bus_rdx"),
                        shared_in=rnd.getrandbits(1))
