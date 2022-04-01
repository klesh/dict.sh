#!/bin/sh

# shellcheck disable=2086,2059

set -e

# compose selector command if not specified
if [ -z "$D_SELECTOR" ]; then
    if command  -v dmenu >/dev/null; then
        D_SELECTOR='dmenu -p dict.sh -i -fn monospace:13 -nb "#626262" -nf  "#bbbbbb" -sb "#5b97f7" -sf "#eeeeee" -l 20'
        dmenu -h 2>&1 | grep -qF ' [-n number]' && D_SELECTOR="$D_SELECTOR -n %i"
        dmenu -h 2>&1 | grep -qP '\[-\w*c\w*\]' && D_SELECTOR="$D_SELECTOR -c"
    else
        D_SELECTOR="plainsel"
    fi
fi
[ "$D_SELECTOR" = "plainsel" ] && D_SELECTOR="SELECTED=%d plainsel"
EMPTY_RESULT=' ¯\_(ツ)_/¯'
GREETING='﬜ ( ͡° ͜ʖ ͡°)_/¯'

request() {
    RESULT="$(
        curl -SsLG "http://dict.youdao.com/w/eng/$SENTENCE/" \
            | d_youdao -v PI=' '
    )"
    display
}

pronounce() {
    ! command -v afplay >/dev/null && ! command -v ffplay >/dev/null && echo 'require either afplay or ffplay' && exit 1
    PLAY=afplay
    ! command -v "$PLAY" 2>/dev/null && PLAY="ffplay -nodisp -autoexit"
    FP="/tmp/dict/$*.mp3"
    mkdir -p /tmp/dict
    [ ! -f "$FP" ] && curl -o  "$FP" "http://dict.youdao.com/dictvoice?audio=$1&type=$2" 1>/dev/null 2>&1
    $PLAY "$FP" 1>/dev/null 2>&1
}

invalidsel() {
    echo "$*" | grep -qF "$EMPTY_RESULT" || echo "$INPUT" | grep -qF "$GREETING"
}

display() {
    R="$RESULT"
    if [ -z "$R" ]; then
        if [ -n "$SENTENCE" ]; then
            R="$EMPTY_RESULT : $SENTENCE"
        else
            R="$GREETING"
        fi
    fi
    SELECT=$(printf "$D_SELECTOR" "$LINE_NUM")
    echo "$R" \
        | eval $SELECT \
        | if IFS= read -r INPUT; then
            # process selected menu item
            if echo "$INPUT" | grep -qP ' '; then
                if echo "$INPUT" | grep -q '美'; then
                    pronounce "$SENTENCE" 2 &
                else
                    pronounce "$SENTENCE" 1 &
                fi
                LINE_NUM=$(echo "$RESULT" | awk -v INPUT="$INPUT" '$0==INPUT { print NR - 1 }')
                display $LINE_NUM
            elif invalidsel "$INPUT"; then
                return
            elif echo "$INPUT" | grep -qP '^ '; then
                printf "%s" "$INPUT" | sed -E 's/^\s+//' |  xsel -b
                echo "'$(xsel -ob)' is copied to clipboard"
            else
                SENTENCE="$INPUT"
                request
            fi
          fi
}


SENTENCE="$*"
SENTENCE=$(sed "s/ /%20/g" <<<"$SENTENCE")
if [ -n "$SENTENCE" ]; then
    request
else
    display
fi
#pronounce "$@"

