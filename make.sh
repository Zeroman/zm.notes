#!/bin/bash - 

# Zeroman Yang (51feel@gmail.com)
# 10/17/2015

set -e

cur_path=$(readlink -f $0)
cur_dir=${cur_path%/*}

convert2html()
{
    local inputdir=$1
    local outputdir=$2
    local prj_name=$3
    local cssfile=$4

    if [ -z "$cssfile" ];then
        cssfile="css/modern.css"
    fi

    local options="-t html"
    options+=" --encoding=utf-8"
    options+=" --toc"
    options+=" --toc-level 3"
    options+=" --css-sugar"
    options+=" --style=$cssfile"

    local t2t_file=$(readlink -m $inputdir/${prj_name}.t2t)
    local htm_file=$(readlink -m $outputdir/${prj_name}.html)

    mkdir -p $outputdir
    test -d "$inputdir/img" && cp -rf $inputdir/img $outputdir
    test -d "$inputdir/css" && cp -rf $inputdir/css $outputdir
    if [ -e "$cssfile" ];then
        mkdir -p $inputdir/css
        cp -rf $cssfile $outputdir/css
    fi
    echo "txt2tags $options -o $htm_file $t2t_file"
    txt2tags $options -o $htm_file $t2t_file
}

convert2tex()
{
    local inputdir=$1
    local outputdir=$2
    local prj_name=$3
    local cssfile=$4

    local options="-t tex"
    options+=" --encoding=utf-8"
    options+=" --toc"
    options+=" --toc-level 3"
    options+=" --style=$cssfile"

    local t2t_file=$(readlink -m $inputdir/${prj_name}.t2t)
    local tex_file=$(readlink -m $outputdir/${prj_name}.tex)

    mkdir -p $outputdir
    echo "txt2tags $options -o $tex_file $t2t_file"
    txt2tags $options -o $tex_file $t2t_file
}

convert2pdf()
{
    local inputdir=$1
    local outputdir=$2
    local prj_name=$3
    local cssfile=$4

    local options="-t pdf"
    options+=" --encoding=utf-8"
    options+=" --toc"
    options+=" --toc-level 3"
    options+=" --style=$cssfile"

    local t2t_file=$(readlink -m $inputdir/${prj_name}.t2t)
    local tex_file=$(readlink -m $outputdir/${prj_name}.tex)
    local pdf_file=$(readlink -m $outputdir/${prj_name}.pdf)

    mkdir -p $outputdir

    local t2tname=$(basename $t2tfile)
    convert2tex $inputdir $outputdir/tex ${t2tname/.t2t}
    echo "convert $pdf_file to $t2t_file"
    tools/format_tex.py $outputdir/tex/${prj_name}.tex ${tex_file}
    test -d $inputdir/img && mkdir -p $outputdir/img
    for img in $(find $inputdir/img/ -type f)
    do
        imgname=$(basename $img)
        convert $img $outputdir/img/${imgname/.*}.eps
    done
    cp tools/zhtexfont.sty $outputdir
    cd $outputdir
    xelatex ${tex_file}
    xelatex ${tex_file}                         # genarate index
    cd $cur_dir
    echo "pdf path: $pdf_file"
}

convert_dir()
{
    local inputdir=$1
    local outputdir=$2
    local converttype=$3

    if [ -e "$inputdir/main.t2t" ];then
        convert${converttype} $inputdir $outputdir main
    else
        for t2tfile in $(find $inputdir -maxdepth 1 -name *.t2t)
        do
            local t2tname=$(basename $t2tfile)
            convert2${converttype} $inputdir $outputdir ${t2tname/.t2t}
        done
    fi
}

convert_all()
{
    local inputdir=$1
    local outputdir=$2
    local converttype=$3

    if [ ! -d "$inputdir" ];then
        return
    fi

    t2tdirs=$(cd $inputdir;find . -type d ! -name *.git)
    for dir in $t2tdirs
    do
        convert_dir $inputdir/$dir $outputdir/$dir $converttype
    done
}

test_dir="test"
convert_all $test_dir output/html html
convert_all $test_dir output/tex tex
convert_all $test_dir output/pdf pdf

