#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "11/input.txt"
    ARGC = 2
    FS = ""
}

{
    for (i = 1; i <= NF; i++) {
        CELLS[NR][i] = $i
    }
}

function flash(y, x, _i, _j) {
    FLASHES++
    for (_i = -1; _i <= 1; _i++) {
        for (_j = -1; _j <= 1; _j++) {
            if (y+_i > 0 && y+_i <= 10 && x+_j > 0 && x+_j <= 10 && (_i != 0 || _j != 0)) {
                CELLS[y+_i][x+_j]++
                if (CELLS[y+_i][x+_j] == 10) {
                    flash(y+_i,x+_j)
                }
            }
        }
    }
}

function step(_y, _x) {
    for (_y = 1; _y <= 10; _y++) {
        for (_x = 1; _x <= 10; _x++) {
            CELLS[_y][_x]++

            if (CELLS[_y][_x] == 10) {
                flash(_y, _x)
            }
        }
    }

    for (_y = 1; _y <= 10; _y++) {
        for (_x = 1; _x <= 10; _x++) {
            if (CELLS[_y][_x] > 9) {
                CELLS[_y][_x] = 0
            }
        }
    }
}

END {
    OLD_FLASHES = 0
    STEPS = 0
    while (!PART_ONE || !PART_TWO) {
        STEPS++
        step()
        
        if (STEPS == 100) {
            PART_ONE = FLASHES
        }

        if (OLD_FLASHES+100 == FLASHES) {
            PART_TWO = STEPS
        }
        OLD_FLASHES = FLASHES
    }
    print(PART_ONE)
    print(PART_TWO)
}