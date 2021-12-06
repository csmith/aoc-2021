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

function total(_t, _f) {
    for (_f in FISH) {
        _t += FISH[_f]
    }
    return _t
}

END {
    for (day = 1; day <= 256; day++) {
        FISH[(day + 6) % 9] += FISH[(day + 8) % 9]

        if (day == 80 || day == 256) {
            print(total())
        }
    }
    
}
