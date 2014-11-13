
echo "Enter the data combination"
grep -r "INSTR_RETIRED_ANY STAT" $1
grep -r "MEM_UOP_RETIRED_LOADS STAT" $1
grep -r "MEM_UOP_RETIRED_STORES STAT" $1
grep -r "Runtime (" $1
grep -r "Energy" $1
grep -r "Power" $1
