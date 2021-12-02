#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "01/input.txt"
    ARGC = 2
}

PREV[2] && $1 > PREV[2] {
    PART_ONE++
}

PREV[0] && $1 > PREV[0] {
    PART_TWO++
}

{
    PREV[0] = PREV[1]
    PREV[1] = PREV[2]
    PREV[2] = $1
}

END {
    print PART_ONE
    print PART_TWO
}
