#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "02/input.txt"
    ARGC = 2
}

BEGIN {
    POSITION = 0
    UPPY_DOWNY = 0 # Depth for part 1, aim for part 2
    P2_DEPTH = 0
}

$1 == "forward" {
    POSITION += $2
    P2_DEPTH += UPPY_DOWNY * $2
}

$1 == "down" {
    UPPY_DOWNY += $2
}

$1 == "up" {
    UPPY_DOWNY -= $2
}

END {
    print POSITION * UPPY_DOWNY
    print POSITION * P2_DEPTH
}
