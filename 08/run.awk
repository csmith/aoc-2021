#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "08/input.txt"
    ARGC = 2
}


{
    gsub("\\|", "")
}

{
    for (i = NF-3; i<= NF; i++) {
        len = length($i)

        if (len <= 4 || len == 7) {
            SIMPLES++
        }
    }
}

#   0:      1:      2:      3:      4:       0 => 6 segs
#  aaaa    ....    aaaa    aaaa    ....      1 => 2 segs
# b    c  .    c  .    c  .    c  b    c     2 => 5 segs
# b    c  .    c  .    c  .    c  b    c     3 => 5 segs
#  ....    ....    dddd    dddd    dddd      4 => 4 segs
# e    f  .    f  e    .  .    f  .    f     5 => 5 segs
# e    f  .    f  e    .  .    f  .    f     6 => 6 segs
#  gggg    ....    gggg    gggg    ....      7 => 3 segs
#                                            8 => 7 segs
#   5:      6:      7:      8:      9:       9 => 6 segs
#  aaaa    aaaa    aaaa    aaaa    aaaa      
# b    .  b    .  .    c  b    c  b    c     2 segs => cf
# b    .  b    .  .    c  b    c  b    c     3 segs => acf
#  dddd    dddd    ....    dddd    dddd      4 segs => bcdf
# .    f  e    f  .    f  e    f  .    f     5 segs => -adg
# .    f  e    f  .    f  e    f  .    f     6 segs => -abfg
#  gggg    gggg    ....    gggg    gggg      7 segs => abcdef

{
    A = 1
    B = 2
    C = 4
    D = 8
    E = 16
    F = 32
    G = 64
}

function isResolved(v) {
    return v == A || v == B || v == C || v == D || v == E || v == F || v == G
}

function toDigit(v) {
    if (v == or(A, B, C, E, F, G)) { return 0 }
    if (v == or(C, F)) { return 1 }
    if (v == or(A, C, D, E, G)) { return 2 }
    if (v == or(A, C, D, F, G)) { return 3 }
    if (v == or(B, C, D, F)) { return 4 }
    if (v == or(A, B, D, F, G)) { return 5 }
    if (v == or(A, B, D, E, F, G)) { return 6 }
    if (v == or(A, C, F)) { return 7 }
    if (v == or(A, B, C, D, E, F, G)) { return 8 }
    if (v == or(A, B, C, D, F, G)) { return 9 }
    print("Invalid digit", v)
    exit
}

{
    for (i = 1; i < 8; i++) {
        options[i] = or(A, B, C, D, E, F, G)
    }

    # First pass - prune the options based on the number of segments
    # If there are 2, 3 or 4 letters we know which possible segments they could be
    # If there are 5, 6 or 7 letters we know what the missing segments _can't_ be
    for (i = 1; i<= NF; i++) {
        len = length($i)

        if (len <= 4) {
            if (len == 2) {
                pattern = or(C, F)
            } else if (len == 3) {
                pattern = or(C, F, A)
            } else if (len == 4) {
                pattern = or(B, C, D, F)
            }

            if ($i ~ "a") { options[1] = and(options[1], pattern) }
            if ($i ~ "b") { options[2] = and(options[2], pattern) }
            if ($i ~ "c") { options[3] = and(options[3], pattern) }
            if ($i ~ "d") { options[4] = and(options[4], pattern) }
            if ($i ~ "e") { options[5] = and(options[5], pattern) }
            if ($i ~ "f") { options[6] = and(options[6], pattern) }
            if ($i ~ "g") { options[7] = and(options[7], pattern) }
        } else if (len < 7) {
            if (len == 5) {
                pattern = or(A, D, G)
            } else if (len == 6) {
                pattern = or(A, B, F, G)
            }

            if ($i !~ "a") { options[1] = and(options[1], compl(pattern)) }
            if ($i !~ "b") { options[2] = and(options[2], compl(pattern)) }
            if ($i !~ "c") { options[3] = and(options[3], compl(pattern)) }
            if ($i !~ "d") { options[4] = and(options[4], compl(pattern)) }
            if ($i !~ "e") { options[5] = and(options[5], compl(pattern)) }
            if ($i !~ "f") { options[6] = and(options[6], compl(pattern)) }
            if ($i !~ "g") { options[7] = and(options[7], compl(pattern)) }
        }
    }

    # Second pass - if we know the segment corresponding to one letter, remove
    # it as an option for all other letters. Repeat until we stop changing things.
    do {
        changed = 0
        for (i = 1; i < 8; i++) {
            if (isResolved(options[i])) {
                for (j = 1; j < 8; j++) {
                    if (j != i) {
                        old = options[j]
                        new = and(options[j], compl(options[i]))
                        if (old != new) {
                            options[j] = new
                            changed = 1
                        }
                    }
                }
            }
        }
    } while (changed)

    sum = 0
    for (i = NF-3; i<= NF; i++) {
        value = 0
        if ($i ~ "a") { value = or(value, options[1]) }
        if ($i ~ "b") { value = or(value, options[2]) }
        if ($i ~ "c") { value = or(value, options[3]) }
        if ($i ~ "d") { value = or(value, options[4]) }
        if ($i ~ "e") { value = or(value, options[5]) }
        if ($i ~ "f") { value = or(value, options[6]) }
        if ($i ~ "g") { value = or(value, options[7]) }
        sum = 10 * sum + toDigit(value)
    }
    PART_TWO += sum

}

END {
    print(SIMPLES)
    print(PART_TWO)
}