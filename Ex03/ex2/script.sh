file_name="data.csv"
new_name="data.txt"

if [ ! -f $file_name ]
then
    echo "$file_name not found"
fi

#2.a
sed -e 's/,//g' -e '/^#/d' $file_name > $new_name

#2.b
counter=0 
while read line; do
    #counting even numbers
    for number in $line; do
        reminder=$(($number % 2))
        if [[ $reminder == 0 ]]
        then
            counter=$(($counter+1))
        fi
    done
done < $new_name
echo "There are $counter even numbers"

#2.c
#separeting lines depending on the radius
out_file="outside_values.txt"
in_file="inside_values.txt"

rm $out_file
rm $in_file
touch $out_file
touch $in_file
R=$( echo 'scale=6;100*sqrt(3)/2' | bc )
index=1 #loop over numbers of each line, compute radius and increase index by 1, when index > 3 don't use number to compute radius
while read line; do
    #compute the radius
    squared_radius=0
    for number in $line; do
        if [[ $index < 4 ]]
        then
            squared_radius=$(($squared_radius+$number^2))
        fi
        index=$(($index+1))
    done
    radius=$(echo "scale=6;sqrt($squared_radius)" | bc)

    #redirect line basing on the radius
    if [[ $radius < $R ]]
    then
        echo $line >> $in_file
    else
        echo $line >> $out_file
    fi
    index=1
done < $new_name

#2.d
dr1="copies"
mkdir dr1
for (( i=1; i<=$1; ++i )); do
    while read line; do
        temp=""
        for number in $line; do
            div=$(echo "scale=6;$number/$i" | bc)
            temp+="$div " 
        done
        echo $temp >> "dr1/data${i}.txt"
    done < $new_name
done