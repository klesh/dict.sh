#!/bin/sh

set -e
DIR="$(dirname "$(readlink -f "$0")")"

# https://unix.stackexchange.com/questions/464930/can-i-read-a-single-character-from-stdin-in-posix-shell
readc() { # arg: <variable-name>
    # if stdin is a tty device, put it out of icanon, set min and
    # time to sane value, but don't otherwise touch other input or
    # or local settings (echo, isig, icrnl...). Take a backup of the
    # previous settings beforehand.
    saved_tty_settings=$(stty -g -F /dev/tty)
    stty -icanon min 1 time 0 -F /dev/tty
    eval "$1="
    while
        # read one byte, using a work around for the fact that command
        # substitution strips the last character.
        c=$(dd bs=1 count=1 2> /dev/null if=/dev/tty; echo .)
        c=${c%.}

        # break out of the loop on empty input (eof) or if a full character
        # has been accumulated in the output variable (using "wc -m" to count
        # the number of characters).
        [ -n "$c" ] && eval "$1=\${$1}"'$c
            [ "$(($(printf %s "${'"$1"'}" | wc -m)))" -eq 0 ]'
    do :; done
    # restore settings saved earlier if stdin is a tty device.
    stty "$saved_tty_settings" -F /dev/tty
}

plainsel() {
    M=$(awk '{print}')
    I=1
    nl=$(printf "\nx"); nl=${nl%x}
    echo "$M" | awk -v SEL_IDX="$I" -f "$DIR/renders/menu.awk" >&2
    while readc C; do
        case "$C" in
            $nl)
                exit
                ;;
            n|j)
                printf '\r   \r'
                ;;
            p|k)
                printf '\r   \r'
                ;;
            *)
                printf  "%s" "$C" | xxd
                ;;
        esac
    done
}


plainsel < text
