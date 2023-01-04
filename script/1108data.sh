#!/bin/bash
N_sub=$1
file_dest="z_exp/1129/1205-3/"

# for i in $(seq 1 $((N_sub))); do
#     awk 'END {total_L=3593 ; printf "%f\n", (NR/total_L) }' ${file_dest}bro_to_sub$i.out.prev >> ${file_dest}loss.txt
    
# done
# for i in $(seq $N_sub $((N_sub*2))); do
#     awk 'END {total_s=361; printf "%f\n", NR/total_s }' ${file_dest}bro_to_sub$i.out.prev >> ${file_dest}loss.txt
# done

for i in $(seq 1 $N_sub)
do
    awk '{end2end=($4-$1); printf "%d\n", end2end}' ${file_dest}bro_to_sub$i.out.prev>> ${file_dest}1205-3_all/end2end_all_S.txt
    awk '{inbro=($3-$2); printf "%d\n", inbro}' ${file_dest}bro_to_sub$i.out.prev>> ${file_dest}1205-3_all/inbro_all_S.txt
done

for i in $(seq 51 $((N_sub*2)))
do
    awk '{end2end=($4-$1); printf "%d\n", end2end}' ${file_dest}bro_to_sub$i.out.prev>> ${file_dest}1205-3_all/end2end_all_L.txt
    awk '{inbro=($3-$2); printf "%d\n", inbro}' ${file_dest}bro_to_sub$i.out.prev>> ${file_dest}1205-3_all/inbro_all_L.txt
done

echo "Done!"
