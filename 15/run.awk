#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "15/input.txt"
    ARGC = 2
    FS = ""
}

{
    for (i = 1; i <= NF; i++) {
        CELLS[(NR-1)*NF+(i-1)] = $i
    }
    
    width = NF
    height++
}

function pick_next(_i) {
    for (_i in set) {
        delete set[_i]
        return _i
    }
}

function run(risks, w, h) {
    start = 0
    target = w*h - 1
    
    delete set
    delete scores

    set[start] = 1
    scores[start] = 0

    while (length(set) > 0) {
        node = pick_next()
        x = node % w
        y = int(node / w)
        for (dx = -1; dx <= 1; dx++) {
            for (dy = -1; dy <= 1; dy++) {
                if (x + dx >= 0 && x + dx < w && y + dy >= 0 && y + dy < h && (dx == 0) != (dy == 0)) {
                    neighbour = (y + dy)*w+x+dx
                    new_score = scores[node] + risks[neighbour]
                    if (scores[neighbour] == 0 || new_score < scores[neighbour]) {
                        scores[neighbour] = new_score
                        set[neighbour] = 1
                    }
                }
            }
        }
    }

    print(scores[target])
}

END {
    run(CELLS, width, height)
    
    new_width = width*5
    new_height = height*5

    for (i in CELLS) {
        x = i % width
        y = int(i / width)
        
        for (dx = 0; dx < 5; dx++) {
            for (dy = 0; dy < 5; dy++) {
                nx = x + dx*width
                ny = y + dy*height
                nv = CELLS[i] + dx + dy
                nv = ((nv-1) % 9)+1
                NEW_CELLS[ny*new_width+nx] = nv
            }
        }
    }

    run(NEW_CELLS, new_width, new_height)
}