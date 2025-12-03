import std/strutils, std/sequtils 

# part1: 2
# part2: 12
const NUM_BATTERIES = 12

proc bankJoltage(bank: string): int =
  var resultStr = ""

  # sentinel value at 0-th elemenet
  var indices = repeat(0, NUM_BATTERIES + 1)
  indices[0] = -1

  for i in 1..NUM_BATTERIES:
    let startIdx = indices[i - 1] + 1
    let s = bank.toSeq[startIdx..^(NUM_BATTERIES + 1 - i)]
    let idx = s.maxIndex + startIdx

    indices[i] = idx
    resultStr &= bank[idx]

  result = resultStr.parseInt

let totalJoltage = stdin.lines
  .toSeq
  .mapIt(bankJoltage(it))
  .foldl(a + b, 0)

echo totalJoltage
