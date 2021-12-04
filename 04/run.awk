#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "04/input.txt"
    ARGC = 2
    FS=","
}

(NR==1) {
    for (i = 1; i <= NF; i++) {
        CALLS[i] = $i
    }
    FS=" "
}

(NR>1 && NF==0) {
    BOARD_NUM++
    LINE_NUM=0
}

(NR>1 && NF>0) {
    for (i = 1; i <= NF; i++) {
        BOARDS[BOARD_NUM][NF*LINE_NUM+i] = $i
    }
    LINE_NUM++
}

function check_winner(b, _i, _lines, _cols, _total) {
    for (_i in BOARDS[b]) {
        if (BOARDS[b][_i] == "X") {
            _lines[_i % 5]++
            _cols[int((_i-1) / 5)]++
        } else {
            _total += BOARDS[b][_i]
        }
    }

    for (_i in _lines) {
        if (_lines[_i] == 5) {
            return _total
        }
    }
    for (_i in _cols) {
        if (_cols[_i] == 5) {
            return _total
        }
    }
    return -1
}

function mark_boards(num, _b, _i, _r) {
    for (_b in BOARDS) {
        if (WINNERS[_b]) {
            continue
        }

        for (_i in BOARDS[_b]) {
            if (BOARDS[_b][_i] == num) {
                BOARDS[_b][_i] = "X"
                _r = check_winner(_b)
                if (_r > -1) {
                    WINNERS[_b] = 1
                    if (FIRST == 0) {
                        FIRST = _r * num
                    }
                    LAST = _r * num
                }
            }
        }
    }
}

END {
    for (i in CALLS) {
        mark_boards(CALLS[i])
    }
    print(FIRST)
    print(LAST)
}