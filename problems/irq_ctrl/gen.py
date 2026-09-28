import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(221)
    st = {"prev": 0, "pend": 0, "mask": 0}

    def outs():
        e = st["pend"] & st["mask"]
        ident = (e & -e).bit_length() - 1 if e else 0
        return e, ident

    def step(name, irq=0, mwe=0, md=0, ack=0, rst=0):
        if rst:
            st.update(prev=0, pend=0, mask=0)
        else:
            e, ident = outs()
            clr = (1 << ident) if (ack and e) else 0
            rise = irq & ~st["prev"] & 0xFF
            st["pend"] = (st["pend"] & ~clr & 0xFF) | rise
            st["prev"] = irq
            if mwe:
                st["mask"] = md
        e, ident = outs()
        return name, {"rst": rst, "irq_in": irq, "mask_we": mwe, "mask_data": md, "ack": ack}, \
            {"irq": int(e != 0), "id": ident, "pending": st["pend"], "mask": st["mask"]}

    yield step("edge sets pending", rst=1)
    yield step("edge sets pending", 0x08)
    yield step("edge sets pending", 0x08)
    yield step("edge sets pending", 0x08, 1, 0xFF)
    yield step("priority and ack", 0x28)
    yield step("priority and ack", 0x28, ack=1)
    yield step("priority and ack", 0x28, ack=1)
    yield step("priority and ack", 0x00, ack=1)
    yield step("masked sources still latch", 0x01, 1, 0xFE)
    yield step("masked sources still latch", 0x00)
    yield step("masked sources still latch", 0x00, 1, 0xFF)
    irq = 0
    for _ in range(3000):
        if rnd.random() < 0.3:
            irq ^= 1 << rnd.randrange(8)
        yield step("3000 random cycles", irq, int(rnd.random() < 0.05), rnd.getrandbits(8), int(rnd.random() < 0.3), rst=int(rnd.random() < 0.002))
