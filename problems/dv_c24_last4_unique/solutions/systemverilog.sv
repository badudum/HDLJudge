class window4;
    rand bit [3:0] val;

    int unsigned prev[$];                           // last three results (not random)
    constraint c_new { foreach (prev[i]) val != prev[i]; }
    function void post_randomize();
        prev.push_back(val);
        if (prev.size() > 3) void'(prev.pop_front());
    endfunction
endclass
