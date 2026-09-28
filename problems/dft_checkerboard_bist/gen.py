import random

CLOCK = "clk"


def cb(a):
    return 0xAA if ((a >> 2) ^ a) & 1 else 0x55


def vectors():
    rnd = random.Random(270)
    mem = [0] * 16
    st = {"busy": 0, "k": 0, "fail": 0, "done": 0, "addr": 0, "we": 0, "wd": 0}
    fault = {"on": False}

    def rd(a):
        v = mem[a]
        if fault["on"] and a == 5:
            v |= 1
        return v

    def cur():
        k = st["k"]
        ph, a = k // 16, k % 16
        exp = cb(a) ^ (0xFF if ph >= 2 else 0)
        return ph, a, exp

    def step(name, start=0, rst=0):
        # memory model: combinational read of the currently presented address
        rdata = rd(st["addr"]) if st["busy"] else 0
        st["done"] = 0
        if rst:
            st.update(busy=0, k=0, fail=0, addr=0, we=0, wd=0)
        elif st["busy"]:
            ph, a, exp = cur()
            if ph in (0, 2):
                mem[a] = exp
            elif rdata != exp:
                st["fail"] = 1
            st["k"] += 1
            if st["k"] == 64:
                st.update(busy=0, done=1, we=0)
            else:
                ph, a, exp = cur()
                st.update(addr=a, we=int(ph in (0, 2)), wd=exp if ph in (0, 2) else 0)
        elif start:
            st.update(busy=1, k=0, fail=0, addr=0, we=1, wd=cb(0))
        return name, {"rst": rst, "start": start, "mem_rdata": rdata}, \
            {"mem_addr": st["addr"] if st["busy"] else None, "mem_we": st["we"] if st["busy"] else 0,
             "mem_wdata": st["wd"] if st["busy"] and st["we"] else None, "busy": st["busy"], "done": st["done"], "fail": st["fail"]}

    yield step("fault-free memory", rst=1)
    yield step("fault-free memory", start=1)
    for _ in range(66):
        yield step("fault-free memory")
    fault["on"] = True
    yield step("stuck-at fault detected", start=1)
    for _ in range(66):
        yield step("stuck-at fault detected")
    fault["on"] = False
    for _ in range(400):
        yield step("restart and reset", start=int(rnd.random() < 0.05), rst=int(rnd.random() < 0.005))
