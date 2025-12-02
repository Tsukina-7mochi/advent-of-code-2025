!/bin/bash

function pick_lang() {
    shuf -e "Rust" "C" "C++" "Go" "TypeScript" "Lua" "Python" "Kotlin" "Scala" "Zsh" | head -n 1
}

printf "Today's Language: $(pick_lang)"

for i in {1..20}; do
    sleep 0.05
    printf "\x1b[E\x1b[KToday's Language: $(pick_lang)"
done

echo
