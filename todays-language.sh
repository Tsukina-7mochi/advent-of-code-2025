!/bin/bash

function pick_lang() {
    shuf -e "Bash" "Zig" | head -n 1
}

printf "\x1b[E\x1b[KToday's Language: $(pick_lang)"

for i in {1..20}; do
    sleep 0.05
    printf "\x1b[E\x1b[KToday's Language: $(pick_lang)"
done

echo
