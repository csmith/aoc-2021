#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "12/input.txt"
    ARGC = 2
    FS = "-"
}

{
    delete PATHS[$1][0]
    delete PATHS[$2][0]
    PATHS[$1][length(PATHS[$1])+1] = $2
    PATHS[$2][length(PATHS[$2])+1] = $1
}

function copy(arr, new, _i) {
    delete new
    for (_i in arr) {
        new[_i] = arr[_i]
    }
}

function traverse(pos, checked, _i, _count, _copy) {
    if (pos ~ /^[a-z]/) { checked[pos] = 1 }
    for (_i in PATHS[pos]) {
        if (PATHS[pos][_i] == "end") {
            _count++
        } else if (!checked[PATHS[pos][_i]]) {
            delete _copy[0][0]
            copy(checked, _copy)
            _count += traverse(PATHS[pos][_i], _copy)
        }
    }
    return _count
}

function traverse_dumbly(pos, checked, used_double, _i, _count, _copy) {
    if (pos ~ /^[a-z]/) { checked[pos] = 1 }
    for (_i in PATHS[pos]) {
        if (PATHS[pos][_i] == "end") {
            _count++
        } else if (!checked[PATHS[pos][_i]]) {
            delete _copy[0][0]
            copy(checked, _copy)
            _count += traverse_dumbly(PATHS[pos][_i], _copy, used_double)
        } else if (!used_double && PATHS[pos][_i] ~ /[a-z]/ && PATHS[pos][_i] != "start") {
            delete _copy[0][0]
            copy(checked, _copy)
            _count += traverse_dumbly(PATHS[pos][_i], _copy, 1)
        }
    }
    return _count
}

END {
    print(traverse("start"))
    print(traverse_dumbly("start"))
}