class size_q;
    rand bit [7:0] q[$];

    constraint c_size { q.size() inside {[3:8]}; }
    constraint c_val  { foreach (q[i]) { q[i] < 10 * q.size(); if (i > 0) q[i] > q[i-1]; } }
endclass
