class ctrl_reg extends uvm_reg;
    `uvm_object_utils(ctrl_reg)
    rand uvm_reg_field en, mode, prescale;
    function new(string name = "ctrl_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        en       = uvm_reg_field::type_id::create("en");
        mode     = uvm_reg_field::type_id::create("mode");
        prescale = uvm_reg_field::type_id::create("prescale");
        //                 parent size lsb access volatile reset has_reset is_rand indiv
        en.configure      (this, 1,   0,  "RW",  0,       1'h0,  1,        1,      0);
        mode.configure    (this, 2,   1,  "RW",  0,       2'h0,  1,        1,      0);
        prescale.configure(this, 8,   8,  "RW",  0,       8'h10, 1,        1,      0);
    endfunction
endclass

class status_reg extends uvm_reg;
    `uvm_object_utils(status_reg)
    uvm_reg_field busy, err;
    function new(string name = "status_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        busy = uvm_reg_field::type_id::create("busy");
        err  = uvm_reg_field::type_id::create("err");
        busy.configure(this, 1, 0, "RO",  1, 1'b0, 1, 0, 0);
        err.configure (this, 1, 1, "W1C", 1, 1'b0, 1, 0, 0);
    endfunction
endclass

class data_reg extends uvm_reg;
    `uvm_object_utils(data_reg)
    rand uvm_reg_field data;
    function new(string name = "data_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        data = uvm_reg_field::type_id::create("data");
        data.configure(this, 32, 0, "RW", 0, 32'h0, 1, 1, 1);
    endfunction
endclass

class regs_block extends uvm_reg_block;
    `uvm_object_utils(regs_block)
    rand ctrl_reg   ctrl;
    rand status_reg status;
    rand data_reg   data;
    function new(string name = "regs_block"); super.new(name, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        ctrl   = ctrl_reg::type_id::create("ctrl");
        status = status_reg::type_id::create("status");
        data   = data_reg::type_id::create("data");
        ctrl.configure(this);   ctrl.build();
        status.configure(this); status.build();
        data.configure(this);   data.build();
        default_map = create_map("map", 'h0, 4, UVM_LITTLE_ENDIAN);
        default_map.add_reg(ctrl,   'h0, "RW");
        default_map.add_reg(status, 'h4, "RW");
        default_map.add_reg(data,   'h8, "RW");
    endfunction
endclass

class bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(bus_adapter)
    function new(string name = "bus_adapter"); super.new(name); endfunction
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        bus_item t = bus_item::type_id::create("t");
        t.write = (rw.kind == UVM_WRITE);
        t.addr  = rw.addr;
        t.data  = rw.data;
        return t;
    endfunction
    virtual function void bus2reg(uvm_sequence_item bus_item_h, ref uvm_reg_bus_op rw);
        bus_item t;
        if (!$cast(t, bus_item_h)) `uvm_fatal("ADAPT", "not a bus_item")
        rw.kind   = t.write ? UVM_WRITE : UVM_READ;
        rw.addr   = t.addr;
        rw.data   = t.data;
        rw.status = UVM_IS_OK;
    endfunction
endclass
