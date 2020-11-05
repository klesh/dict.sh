#!/bin/awk

BEGIN {
    if (color) {
        HEAD = " \033[33m\033[1m%s\033[0m\n"
        TRAN = "  \033[32m%s\033[0m\n"
        SYNO = "   %s\n"
    } else {
        HEAD = " %s\n"
        TRAN = "  %s\n"
        SYNO = "   %s\n"
    }
    stop = 0
}

!stop {
    if (match($0, /<meta name="keywords" content="(.+)"\/>/, m)) {
        sentence = m[1]
    } else if (match($0, /<span class="pronounce">(\w)/, m)) {
        pronounce = m[1]
    } else if (match($0, /<span class="phonetic">(.+)<\/span>/, m)) {
        phonetic = m[1]
    } else if (match($0, /<li>([a-z]+\..+)<\/li>/, m)) {
        if (sentence) {
            printf HEAD, sentence
            sentence = ""
        }
        printf TRAN, m[1]
    } else if (match($0, /<div id="synonyms"/)) {
        synonyms = 1
        printf HEAD, "同近义词"
    } else if (synonyms && match($0, /<a .+>(.+)<\/a>/, m)) {
        printf SYNO, m[1]
    } else if (synonyms && match($0, /<\/div>/)) {
        stop = 1
    } else if (match($0, /id="webTrans"/, m) && back) {
        stop = 1
    } else if (match($0, /<span class="contentTitle".*>(.+)<\/a>/, m)) {
        # eng to chn
        back = 1
        printf TRAN, m[1]
    }
    if (pronounce && phonetic) {
        printf "  %s %s %s\n", PI, pronounce, phonetic
        pronounce = ""
        phonetic = ""
    }
}
