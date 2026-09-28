import random

CLOCK = "clk"


def vectors():
    rnd = random.Random(222)
    st = {"busy": 0, "c": 0, "tx": 0, "rx": 0, "rxd": 0, "sclk": 0, "mosi": 0, "cs": 1, "done": 0, "slave": 0}

    def step(name, start=0, txd=0, rst=0, slave=None):
        # slave drives miso: bit (7 - index) of its byte, index = number of rising sclk edges so far
        miso = (st["slave"] >> (7 - min(st["c"] // 4, 7))) & 1 if st["busy"] else rnd.getrandbits(1)
        st["done"] = 0
        if rst:
            st.update(busy=0, c=0, rxd=0, sclk=0, mosi=0, cs=1)
        elif st["busy"]:
            cn = st["c"] + 1
            st["c"] = cn
            if cn % 4 == 2:
                st["sclk"] = 1
                st["rx"] = ((st["rx"] << 1) | miso) & 0xFF
            elif cn % 4 == 0:
                st["sclk"] = 0
                if cn < 32:
                    st["mosi"] = (st["tx"] >> (7 - cn // 4)) & 1
                else:
                    st.update(cs=1, busy=0, mosi=0, done=1, rxd=st["rx"])
        elif start:
            st.update(busy=1, c=0, tx=txd, cs=0, mosi=(txd >> 7) & 1, rx=0)
            st["slave"] = slave if slave is not None else rnd.getrandbits(8)
        return name, {"rst": rst, "start": start, "tx_data": txd, "miso": miso}, \
            {"sclk": st["sclk"], "mosi": st["mosi"], "cs_n": st["cs"], "busy": st["busy"], "done": st["done"], "rx_data": st["rxd"]}

    yield step("full-duplex byte", rst=1)
    yield step("full-duplex byte", 1, 0xA5, slave=0x3C)
    for _ in range(34):
        yield step("full-duplex byte")
    yield step("start while busy is ignored", 1, 0x81, slave=0xC3)
    for i in range(35):
        yield step("start while busy is ignored", 1 if i == 10 else 0, 0xFF)
    for _ in range(4000):
        yield step("4000 random cycles", int(rnd.random() < 0.1), rnd.getrandbits(8), rst=int(rnd.random() < 0.001))
