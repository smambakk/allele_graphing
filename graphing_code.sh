#!/bin/bash
dir=$1
for dir; do
        cd $dir
        Rscript ~/Pollen_Crosses/graph_code
done
echo 'DONE!'
