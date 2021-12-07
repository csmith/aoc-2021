#!/usr/bin/awk -f

BEGIN {
    ARGV[1] = "07/input.txt"
    ARGC = 2
    RS=","
}

{
    CRABS[NR] = $1
    TOTAL += $1
}

END {
    # Urgh, maths.
    #
    # For part one, the lowest amount of fuel is going to be to assemble
    # at the middle-most crab (i.e., the median). Even with an extreme outlier
    # like [0,1,100], it's better for the crab at 100 to do a solo journey
    # all the way to 1 than for the others to both go out to 50.
    #
    # Both the demo input and my input are odd, so I've not bothered handling
    # the case where the number of crabs is even (where they'd have to meet
    # between the two middle crabs.)
    #
    # For part two, the amount of fuel used by each crab is the Nth triangular
    # number (https://oeis.org/A000217) calculated as n(n+1)/2. Yay OEIS.
    #
    # The mean feels like the obvious meeting point, but rounding the mean
    # works for the demo input, but not my input (the mean is 474.523 and
    # the optimal position is 474). This suggests the mean is not actually
    # right, but given it's within 1.0 of the right place for both inputs
    # I'm just going to run with it. To work around the "which way do we
    # round?" issue I'm just calculating the fuel used for both possibilities.

    n = asort(CRABS)
    median = CRABS[int(n/2)]
    mean_1 = int((TOTAL / n))
    mean_2 = int((TOTAL / n) + 1)

    for (i = 1; i <= n; i++) {
        if (CRABS[i] < median) {
            p1_fuel += median - CRABS[i]
        } else {
            p1_fuel += CRABS[i] - median
        }

        if (CRABS[i] < mean_1) {
            distance = mean_1 - CRABS[i]
        } else {
            distance = CRABS[i] - mean_1
        }
        p2_fuel_1 += (distance * (distance + 1))/2

        if (CRABS[i] < mean_2) {
            distance = mean_2 - CRABS[i]
        } else {
            distance = CRABS[i] - mean_2
        }
        p2_fuel_2 += (distance * (distance + 1))/2
    }
    

    print(p1_fuel)
    if (p2_fuel_1 < p2_fuel_2) {
        print(p2_fuel_1)
    } else {
        print(p2_fuel_2)
    }
}