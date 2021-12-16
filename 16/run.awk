#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "16/input.txt"
    ARGC = 2
    FS = ""

    # This does not spark joy.
    HEX2BIN["0"] = "0000"
    HEX2BIN["1"] = "0001"
    HEX2BIN["2"] = "0010"
    HEX2BIN["3"] = "0011"
    HEX2BIN["4"] = "0100"
    HEX2BIN["5"] = "0101"
    HEX2BIN["6"] = "0110"
    HEX2BIN["7"] = "0111"
    HEX2BIN["8"] = "1000"
    HEX2BIN["9"] = "1001"
    HEX2BIN["A"] = "1010"
    HEX2BIN["B"] = "1011"
    HEX2BIN["C"] = "1100"
    HEX2BIN["D"] = "1101"
    HEX2BIN["E"] = "1110"
    HEX2BIN["F"] = "1111"
}

function bin2dec(bin,    i, len, out) {
    out = 0
    len = length(bin)
    for (i = 1; i <= len; i++) {
        if (substr(bin,i,1) == "1") {
            out = or(out, lshift(1, len-i))
        }
    }
    return out
}

function read_literal(    buf) {
    while (substr(DATA, OFFSET, 1) == "1") {
        buf = buf substr(DATA, OFFSET+1, 4)
        OFFSET += 5
    }
    buf = buf substr(DATA, OFFSET+1, 4)
    OFFSET += 5
    return bin2dec(buf)
}

function evaluate(type, values,    i, res) {
    if (type == 0) {
        # Sum
        for (i in values) {
            res += values[i]
        }
    } else if (type == 1) {
        # Product
        res = 1
        for (i in values) {
            res *= values[i]
        }
    } else if (type == 2) {
        # Minimum
        res = 2^PREC
        for (i in values) {
            if (values[i] < res) {
                res = values[i]
            }
        }
    } else if (type == 3) {
        # Maximum
        res = -2^PREC
        for (i in values) {
            if (values[i] > res) {
                res = values[i]
            }
        }
    } else if (type == 5) {
        # Greater than
        if (values[0] > values[1]) {
            res = 1
        }
    } else if (type == 6) {
        # Less than
        if (values[0] < values[1]) {
            res = 1
        }
    } else if (type == 7) {
        # Equal to
        if (values[0] == values[1]) {
            res = 1
        }
    }

    return res
}

function read_packet(    version, type, value, values, count) {
    version = bin2dec(substr(DATA, OFFSET, 3))
    type = bin2dec(substr(DATA, OFFSET + 3, 3))
    OFFSET += 6
    
    if (type == 4) {
        value = read_literal()
    } else if (substr(DATA, OFFSET, 1) == "0") {
        # Next 15 bits are the total length in bits
        count = OFFSET + 16 + bin2dec(substr(DATA, OFFSET+1, 15))
        OFFSET += 16
        delete values[0]
        while (OFFSET < count) {
            values[length(values)] = read_packet()
        }
        value = evaluate(type, values)
    } else {
        # Next 11 bits are the total number of subpackets
        count = bin2dec(substr(DATA, OFFSET+1, 11))
        OFFSET += 12
        delete values[0]
        while (count > 0) {
            count--
            values[length(values)] = read_packet()
        }
        value = evaluate(type, values)
    }

    VERSIONS += version
    return value
}

{
    DATA = ""
    OFFSET = 1
    for (i = 1; i <= NF; i++) {
        DATA = DATA HEX2BIN[$i]
    }
    PART_TWO = read_packet()
}

END {
    print(VERSIONS)
    print(PART_TWO)
}