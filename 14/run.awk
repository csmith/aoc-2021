#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "14/input.txt"
    ARGC = 2
    FS = ""
}

NR==1 {
    for (i = 1; i < NF; i++) {
        PAIRS[$i$(i+1)]++
        LETTERS[$i]++
    }
    LETTERS[$NF]++
    FS = " -> "
}

NR > 1 && NF == 2 {
    delete TRANSLATIONS[$1] # Look, Ma, I'm an array!
    TRANSLATIONS[$1][0] = substr($1,1,1) $2
    TRANSLATIONS[$1][1] = $2 substr($1,2,1)
    TRANSLATIONS[$1][2] = $2
}

function step(_newpairs, _i) {
    for (_i in PAIRS) {
        _newpairs[TRANSLATIONS[_i][0]] += PAIRS[_i]
        _newpairs[TRANSLATIONS[_i][1]] += PAIRS[_i]
        LETTERS[TRANSLATIONS[_i][2]] += PAIRS[_i]
    }

    # Oh, Awk, why are you so awkful? :(
    delete PAIRS
    for (_i in _newpairs) {
        PAIRS[_i] = _newpairs[_i]
    }
}

function run(steps) {
    for (i = 0; i < steps; i++) { step() }

    min = 2^PREC
    max = -1
    for (i in LETTERS) {
        if (LETTERS[i] < min) { min = LETTERS[i] }
        if (LETTERS[i] > max) { max = LETTERS[i] }
    }
    print(max-min)
}

END {
    run(10)
    run(30)
}