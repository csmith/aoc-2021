#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "10/input.txt"
    ARGC = 2
    FS = ""
}

function opener(b) {
    if (b == "}") { return "{" }
    if (b == ")") { return "(" }
    if (b == ">") { return "<" }
    if (b == "]") { return "[" }
    print("Tried to match", b)
    exit
}

function p1_score(b) {
    if (b == "}") { return 1197 }
    if (b == ")") { return 3 }
    if (b == ">") { return 25137 }
    if (b == "]") { return 57 }
    print("Tried to score", b)
    exit
}

function p2_score(b) {
    if (b == "(") { return 1 }
    if (b == "[") { return 2 }
    if (b == "{") { return 3 }
    if (b == "<") { return 4 }
    print("Tried to score", b)
    exit
}

BEGIN {
    # It's an array, honest.
    delete AUTOCOMPLETE_SCORES[0]
}

{
    pos = 0
    corrupt = 0
    for (i = 1; i <= NF; i++) {
        if ($i == "{" || $i == "[" || $i == "<" || $i == "(") {
            pos++
            openers[pos] = $i
        } else {
            open = opener($i)
            if (openers[pos] == open) {
                pos--
            } else {
                CHECKER_SCORE += p1_score($i)
                corrupt = 1
                break
            }
        }
    }

    if (!corrupt) {
        total = 0
        while (pos >= 1) {
            total = total*5 + p2_score(openers[pos])
            pos--
        }
        AUTOCOMPLETE_SCORES[length(AUTOCOMPLETE_SCORES)] = total
    }
}

END {
    print(CHECKER_SCORE)
    asort(AUTOCOMPLETE_SCORES)
    print(AUTOCOMPLETE_SCORES[int(0.5+length(AUTOCOMPLETE_SCORES)/2)])
}