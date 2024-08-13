#!/usr/bin/env bash
#IN DIR Pollen_Crosses:
dir=$1
for dir; do
        cd $dir
        for each in *; do

                #counting F/non-F for the inference data
                nf=$(grep -o nonfluorescent $each | wc -l) 
                f=$(grep -v nonfluorescent $each | grep -o fluorescent | wc -l)
                total=$(($nf + $f))

                #counting F/non-F for the manually annotated data. if can read via xmlstarlet, might be easier than this.
                numlines=$(awk '/<Type>1<\/Type>/ {b=NR; next} /<Type>2<\/Type>/ {print NR-b-1; exit}' $each)
                fluo="$(((($numlines-2))/5))"
                numi=$(awk '/<Type>2<\/Type>/ {b=NR; next} /<Type>3<\/Type>/ {print NR-b-1; exit}' $each)
                nonfluo="$(((($numi-2))/5))"
                man_total=$(($nonfluo + $fluo))

                #INFERENCE DATA
                #writing totals
                if [ $total == 0 ]; then
                        echo $total  >> /dev/null
                else
                        echo $total >> PC_total.txt
                        echo "scale=2 ; $f / $total" | bc >> PC_ratio.txt
                fi


                #writing name
                if [[ $each == *"inference.xml" ]]; then
                        echo $each >> PC_name.txt
                else
                        echo $each >> /dev/null
                fi


                #MANUAL DATA
                #writing totals
                if [ $man_total == 0 ]; then
                        echo $man_total; >> /dev/null
                else
                        echo $man_total >> PC_total.txt
                        echo "scale=2 ; $fluo / $man_total" | bc >> PC_ratio.txt
                fi

                #writing name
                if [[ $each == *".xml" &&  $each != *"inference"* ]]; then
                        echo $each >> PC_name.txt
                else
                        echo $each >> /dev/null
                fi

                #writing type. from this you want to have an annotated file with H/S crosses and extract those columns into a file, mine is called HVY_SPS
                type=$(grep "$each" ~/Pollen_Crosses/HVY_SPS)
                if [[ $type == *"HVY" ]]; then
                        echo HVY >> PC_type.txt
                elif [[ $type == *"SPS" ]]; then
                        echo SPS >> PC_type.txt
                else
                        echo REG >> PC_type.txt
                fi

        done
        paste PC_total.txt PC_ratio.txt PC_name.txt PC_type.txt>> PC_combined.txt
done
echo 'DONE!'
