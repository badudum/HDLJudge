class draws5;
    rand bit [2:0] val;

    int unsigned prev[$];
    constraint c_dom { val inside {[0:4]}; }
    constraint c_new { foreach (prev[i]) val != prev[i]; }
    function void post_randomize();
        prev.push_back(val);
        if (prev.size() > 3) void'(prev.pop_front());
    endfunction
endclass
