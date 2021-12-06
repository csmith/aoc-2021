#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "06/input.txt"
    ARGC = 2
    FS=","
}

{
    for (i = 1; i <= NF; i++) {
        FISH[$i]++
    }
}

function step(_f, _carry) {
    for (_f = 0; _f <= 8; _f++) {
        if (_f == 0) {
            _carry = FISH[0]
        } else {
            FISH[_f-1] = FISH[_f]
        }
    }
    
    FISH[6] += _carry
    FISH[8] =  _carry
}

function total(_t, _f) {
    for (_f in FISH) {
        _t += FISH[_f]
    }
    return _t
}

END {
    for (i = 1; i <= 80; i++) {
        step()
    }
    print(total())
}

END {
    for (i = 81; i <= 256; i++) {
        step()
    }
    print(total())
}