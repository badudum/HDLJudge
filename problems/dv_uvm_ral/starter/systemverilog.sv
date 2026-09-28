class ctrl_reg extends uvm_reg;
    `uvm_object_utils(ctrl_reg)
    rand uvm_reg_field en, mode, prescale;
    function new(string name = "ctrl_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        // TODO
    endfunction
endclass

class status_reg extends uvm_reg;
    `uvm_object_utils(status_reg)
    uvm_reg_field busy, err;
    function new(string name = "status_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        // TODO
    endfunction
endclass

class data_reg extends uvm_reg;
    `uvm_object_utils(data_reg)
    rand uvm_reg_field data;
    function new(string name = "data_reg"); super.new(name, 32, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        // TODO
    endfunction
endclass

class regs_block extends uvm_reg_block;
    `uvm_object_utils(regs_block)
    rand ctrl_reg   ctrl;
    rand status_reg status;
    rand data_reg   data;
    function new(string name = "regs_block"); super.new(name, UVM_NO_COVERAGE); endfunction
    virtual function void build();
        // TODO: create + configure + build registers, create default_map, add registers
    endfunction
endclass

class bus_adapter extends uvm_reg_adapter;
    `uvm_object_utils(bus_adapter)
    function new(string name = "bus_adapter"); super.new(name); endfunction
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        // TODO
        return null;
    endfunction
    virtual function void bus2reg(uvm_sequence_item bus_item_h, ref uvm_reg_bus_op rw);
        // TODO
    endfunction
endclass
