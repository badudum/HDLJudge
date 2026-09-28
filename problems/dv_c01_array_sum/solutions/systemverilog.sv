class sum_item;
    rand bit [7:0] arr[8];

    constraint c_sum   { arr.sum() with (int'(item)) == 200; }
    constraint c_range { foreach (arr[i]) arr[i] inside {[5:60]}; }
    constraint c_even  { arr[0] % 2 == 0; }
endclass
