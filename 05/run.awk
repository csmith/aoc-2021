#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "05/input.txt"
    ARGC = 2
    FS=","
}

{
    gsub(" -> ",",")
}

$1 == $3 {
    # Same x-axis co-ord
    min = $2 < $4 ? $2 : $4
    max = $2 < $4 ? $4 : $2
    for (y = min; y <= max; y++) {
        STRAIGHT_CROSSES[y][$1]++
        ALL_CROSSES[y][$1]++
    }
}

$2 == $4 {
    # Same y-axis co-ord
    min = $1 < $3 ? $1 : $3
    max = $1 < $3 ? $3 : $1
    for (x = min; x <= max; x++) {
        STRAIGHT_CROSSES[$2][x]++
        ALL_CROSSES[$2][x]++
    }
}

$1 != $3 && $2 != $4 {
    # Diagonal
    xdir = $1 < $3 ? 1 : -1
    ydir = $2 < $4 ? 1 : -1
    steps = $2 < $4 ? ($4 - $2) : ($2 - $4)
    x = $1
    y = $2
    for (i = 0; i <= steps; i++) {
        ALL_CROSSES[y][x]++
        x += xdir
        y += ydir
    }
}

function sum(arr, _x, _y, _t) {
    for (_y in arr) {
        for (_x in arr[_y]) {
            if (arr[_y][_x] >= 2) {
                _t++
            }
        }
    }
    return _t
}

END {
    print(sum(STRAIGHT_CROSSES))
    print(sum(ALL_CROSSES))
}