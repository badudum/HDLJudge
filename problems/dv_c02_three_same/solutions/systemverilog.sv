class three_same;
    rand bit [3:0] arr[10];

    rand bit [3:0] rep;                       // the repeated value
    constraint c_rep  { arr.sum() with (int'(item == rep)) == 3; }
    constraint c_uniq { foreach (arr[i]) foreach (arr[j]) if (i < j) (arr[i] == arr[j]) -> (arr[i] == rep); }
endclass
