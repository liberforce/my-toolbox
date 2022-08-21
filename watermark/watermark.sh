#! /bin/bash

# Usage: watermark.sh IMAGE TEXT
#
# Goal: Imprints a TEXT on an IMAGE, resulting in a watermarked PDF.
#       The resulting PDF is generated in the same directory as the source
#       image.

FILLER_TEXT_FILE="filler.txt"

watermark()
{
    local input=$1
    local output=$2

    convert \
        -density 150 \
        "${input}" \
        -gravity center \
        -pointsize 8 \
        -fill 'rgba(100, 100, 100, 0.25)' \
        -draw "text 0,0 '$(cat ${FILLER_TEXT_FILE})'" \
        -fill blue \
        -compress zip \
        "${output}"
}

get_outname()
{
    local inname=$1
    echo ${inname%%.*}-watermarked.pdf
}

create_filler_text()
{
    local text=$1
    local n_times_on_line=4
    local n_lines=300
    > "${FILLER_TEXT_FILE}"
    line=$(printf " ${text}%.0s -" $(seq $n_times_on_line))
    line_length="${#line}"
    let wrap_index=${line_length}-1

    for i in $(seq $n_lines); do
        line="${line: -1}${line:0:$wrap_index}"
        echo -e "$line\n" >> "${FILLER_TEXT_FILE}"
    done
}

main()
{
    inname=$1
    outname=$(get_outname "${inname}")
    text=$2

    create_filler_text "${text}"
    watermark "${inname}" "${outname}"
}

main2()
{
    inname=$1
    outname=$(get_outname "${inname}")

    convert \
        -background None \
        -fill "rgba(64, 64, 64, 0.50)" \
        -pointsize 20 label:"Mon texte" \
        -rotate -20 +repage  +write mpr:TILE +delete "${inname}" \
        -alpha set \
        \( \
            +clone \
            -fill mpr:TILE \
            -draw "color 0,0 reset" \
        \) \
        -composite  "${outname}"
}

main "$@"
