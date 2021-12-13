#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "13/input.txt"
    ARGC = 2
    FS = "[, =]"
}

BEGIN {
    PHASE = 1
}

PHASE==1 {
    delete DOTS[$1][-1]
    DOTS[$1][$2] = 1
    if ($1 > WIDTH) { WIDTH = $1 }
    if ($2 > HEIGHT) { HEIGHT = $2 }
}

PHASE==2 && $3=="x" {
    # Folding the right side onto the left side
    for (x = WIDTH; x >= $4; x--) {
        newX = $4 - (x - $4)
        for (y = 0; y <= HEIGHT; y++) {
            DOTS[newX][y] = or(DOTS[newX][y], DOTS[x][y])
        }
        delete DOTS[x]
        WIDTH--
    }
}

PHASE==2 && $3=="y" {
    # Folding the bottom side onto the top side
    for (y = HEIGHT; y >= $4; y--) {
        newY = $4 - (y - $4)
        for (x = 0; x <= WIDTH; x++) {
            DOTS[x][newY] = or(DOTS[x][newY], DOTS[x][y])
            delete DOTS[x][y]
        }
        HEIGHT--
    }
}

PHASE==2 && !FIRST {
    for (y = 0; y <= HEIGHT; y++) {
        for (x = 0; x <= WIDTH; x++) {
            if (DOTS[x][y]) {
                count++
            }
        }
    }
    print(count)
    FIRST=1
}

/^$/ {
    PHASE = 2
}

END {
    # Stolen from https://github.com/ShaneMcC/aoc-2021/blob/master/common/decodeText.php
    LETTERS["011001001010010111101001010010"] = "A"
    LETTERS["111001001011100100101001011100"] = "B"
    LETTERS["011001001010000100001001001100"] = "C"
    LETTERS["111101000011100100001000011110"] = "E"
    LETTERS["111101000011100100001000010000"] = "F"
    LETTERS["011001001010000101101001001110"] = "G"
    LETTERS["100101001011110100101001010010"] = "H"
    LETTERS["001100001000010000101001001100"] = "J"
    LETTERS["100101010011000101001010010010"] = "K"
    LETTERS["100001000010000100001000011110"] = "L"
    LETTERS["111001001010010111001000010000"] = "P"
    LETTERS["111001001010010111001010010010"] = "R"
    LETTERS["100101001010010100101001001100"] = "U"
    LETTERS["100011000101010001000010000100"] = "Y"
    LETTERS["111100001000100010001000011110"] = "Z"
    LETTERS["000000000000000000000000000000"] = " "

    for (i = 0; i < 8; i++) {
        letter = ""
        for (y = 0; y <= HEIGHT; y++) {
            for (x = i*5; x < (i+1)*5; x++) {
                if (DOTS[x][y]) {
                    letter = letter 1
                } else {
                    letter = letter 0
                }
            }
        }
        printf(LETTERS[letter])
    }
    printf("\n")
}