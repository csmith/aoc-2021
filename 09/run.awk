#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "09/input.txt"
    ARGC = 2
    FS = ""
}

{
    for (i = 1; i <= NF; i++) {
        # Flip the heights so anything that's undefined (outside our grid)
        # counts as "higher" than those inside, so we don't need to bounds
        # check later on.
        #
        # This works out as:
        #  -1 -> Cell has been counted as a basin for part 2
        #   0 -> Cell is outside the known grid
        #   1 -> Cell had a value of 9
        #   ...
        #  10 -> Cell had a value of 0
        #
        # Which also lets us flood-fill anything with a value >1 for part 2.
        GRID[NR][i] = 10-$i
    }
}

function flood(y, x, _size) {
    GRID[y][x] = -1
    _size = 1
    if (GRID[y-1][x] > 1) { _size += flood(y-1, x) }
    if (GRID[y+1][x] > 1) { _size += flood(y+1, x) }
    if (GRID[y][x-1] > 1) { _size += flood(y, x-1) }
    if (GRID[y][x+1] > 1) { _size += flood(y, x+1) }
    return _size
}

END {
    delete BASINS[0] # "Declare" an array

    for (y in GRID) {
        for (x in GRID[y]) {
            val = GRID[y][x]
            if (val > 1 && GRID[y-1][x] < val && GRID[y+1][x] < val && GRID[y][x-1] < val && GRID[y][x+1] < val) {
                RISK += 11-val
                BASINS[length(BASINS)] = flood(y, x)
            }
        }
    }
    print(RISK)
    
    n = asort(BASINS)
    print(BASINS[n] * BASINS[n-1] * BASINS[n-2])
}