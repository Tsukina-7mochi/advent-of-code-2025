!/bin/bash

function pick_lang() {
    shuf -e "C++" "Go" "TypeScript" "Bash" "Zig" "OCaml" | head -n 1
}

printf ""

for i in {1..20}; do
    sleep 0.05
    printf "\x1b[E\x1b[KToday's Language: $(pick_lang)"
done

echo
