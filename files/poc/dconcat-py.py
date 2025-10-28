from zoautil_py import datasets

result=datasets.compare('employee.source.seq', 'employee.added.seq')
lines = result.split('\n')

# For debug purposes
# for line in lines:
#    print(line)

new_lines = []
for line in lines:
   if line.startswith("I -"):
      new_lines.append(line[4:84])

# For debug purposes
# for new_line in new_lines:
#    print(new_line)

#For debug purposes
for new_line in new_lines:
   print(new_line)
   print(len(new_line))

dataset = datasets.create(name="result.concat.seq", dataset_type="SEQ")

for new_line in new_lines:
    datasets.write("result.concat.seq", new_line, True)


        # if [ -n "$3" ]; then
        #     #echo "DS1 and DS2 are diffed and inserted into D3"
        #     delta=`ddiff "$1" "$2" | tail -n +7|grep "^I -" |cut -c5-84`
        #     printf '%s' "$delta" | decho $3
        #     delta=`ddiff "$1" "$2" | tail -n +7|grep "^D -" |cut -c5-84`
        #     echo "$delta" | decho -a $3
        #     exit
        # fi

        # if [[ "$reverse" == "true" ]]; then
        #     # echo "DS1 and DS2 are diffed and inserted into DS2 (reverse order)"
        #     delta=`ddiff "$1" "$2" | tail -n +7|grep "^D -" |cut -c5-84`
        #     echo "$delta" | decho -a $2
        #     exit
        # fi

        # # echo "DS1 and DS2 are diffed and inserted into DS1"
        # delta=`ddiff "$1" "$2" | tail -n +7|grep "^I -" |cut -c5-84`
        # echo "$delta" | decho -a $1
        # exit