class axi_burst;
    rand bit [31:0] addr;
    rand bit [31:0] len;     // beats - 1 (0..15)
    rand bit [31:0] size;    // bytes per beat = 1 << size (0..2)

    // Your constraints here

endclass
