#!/bin/bash

# Adapter from glenn Jag on http://askubuntu.com/questions/180612/script-to-mute-an-application
# Toggles muting of all audio streams of an app

main() {
    if [[ "$1" ]]; then
        prev=""; prev2="";
        while read line; do
            if [[ $line = "end" ]]; then
                adjust_muteness $1 $(echo "$prev2 $prev" | tr -d '\n')
                prev=""; prev2="";
            else
                if [[ $prev2 = "" ]]; then prev2=$line; else prev=$line; fi
            fi
        done < <(get_info "$1")
    else
        usage 1 "specify the name of a PulseAudio client"
    fi
}

usage() {
    [[ "$2" ]] && echo "error: $2"
    echo "usage: $0 [-h] [-u] appname"
    exit $1
}

adjust_muteness() {
    # muted or not
    muted=$2
    # process ID
    index=$3

    # muteness value
    if [[ $muted = "yes" ]]; then
        mute=0 # unmute
    else
        mute=1 # mute
    fi

    echo $muted

    if [[ -z "$index" ]]; then
        echo "error: no PulseAudio sink named $1 was found" >&2
    else
        [[ "$index" ]] && pacmd set-sink-input-mute "$index" $mute >/dev/null
    fi
}

get_info() {
    pacmd list-sink-inputs |
    awk -v name=$1 '
        $1 == "index:" {idx = $2}
        $1 == "muted:" {idm = $2}
        $1 == "application.name" && $3 == "\"" name "\"" {print idm; print idx; print "end";}
    '
}

main "$@"