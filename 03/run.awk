#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "03/input.txt"
    ARGC = 2
    FS = ""
}

{
    for (i = 1; i <= NF; i++) {
        VALUES[i] += $i
        OXYGEN[NR][i] = $i
        CO2[NR][i] = $i
    }
}

END {
    EPSILON = 0
    GAMMA = 0
    HALF = NR/2

    for (i in VALUES) {
        if (VALUES[i] > HALF) {
            GAMMA += lshift(1, NF-i)
        } else {
            EPSILON += lshift(1, NF-i)
        }
    }

    print EPSILON*GAMMA
}

function most_common(arr, n, default, _i, _sum, _total) {
    _sum = 0
    _total = 0
    for (_i in arr) {
        _sum += arr[_i][n]
        _total++
    }

    if (_sum == _total/2) {
        return default
    } else if (_sum > _total/2) {
        return 1
    } else {
        return 0
    }
}

function filter(arr, n, target, _i, _len) {
    _len = 0
    for (_i in arr) {
        if (arr[_i][n] != target) {
            delete arr[_i]
        } else {
            _len++
        }
    }
    return _len
}

function applyCriteria(arr, invert, _i, _j, _k, _common, _len, _value) {
    _i = 1
    do {
        _common = most_common(arr, _i, 1)
        if (invert) {
            _common = 1 - _common
        }
        _len = filter(arr, _i, _common)
        _i++
    } while (_len > 1)
    
    _value = 0
    for (j in arr) {
        for (k in arr[j]) {
            _value += lshift(arr[j][k], NF-k)
        }
    }
    return _value
}

END {
    print applyCriteria(OXYGEN, 0) * applyCriteria(CO2, 1)
}