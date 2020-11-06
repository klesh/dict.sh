#!/bin/awk

BEGIN {
    FMT="  %s\n"
    SEL_FMT="\033[32m\033[1m> %s\033[0m\n"
    #SEL_IDX=1
}

{
    printf NR == SEL_IDX ? SEL_FMT : FMT, $0
}
