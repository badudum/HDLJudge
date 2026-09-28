class rep_rules;
    rand int unsigned len;
    rand bit [7:0] arr[];

    constraint c_len  { len inside {[5:12]}; arr.size() == len; }
    constraint c_val  { foreach (arr[i]) arr[i] inside {[0:9]}; }
    constraint c_adj  { foreach (arr[i]) if (i > 0) arr[i] != arr[i-1]; }
    constraint c_rep  { foreach (arr[i]) foreach (arr[j]) foreach (arr[k])
                            if (i < j && j < k) !(arr[i] == arr[j] && arr[j] == arr[k]); }
endclass
