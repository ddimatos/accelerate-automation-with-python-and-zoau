from zoautil_py import datasets

# Extract "I -" from ddiff to find the differences coming from the second source
# Extract "D -" from ddiff to find the differences coming from the first source

result=datasets.compare('employee.source.seq', 'employee.added.seq')
lines = result.split('\n')

# For debug purposes
# for line in lines:
#    print(line)

new_lines = []
for line in lines:
   if line.startswith("I -"):
      new_lines.append(line[4:])

# For debug purposes
# for new_line in new_lines:
#    print(new_line)