package main

import (
	"bufio"
	"fmt"
	"os"
)

const StartRune = 'S'
const EmptyRune = '.'
const SplitterRune = '^'

type Board [][]rune

func readBoard(scanner *bufio.Scanner) Board {
	var result [][]rune
	for scanner.Scan() {
		row := []rune{EmptyRune}
		for _, r := range scanner.Text() {
			row = append(row, r)
		}
		row = append(row, EmptyRune)

		result = append(result, row)
	}

	return result
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	board := readBoard(scanner)

	numBeams := make([]int, len(board[0]))
	for i, r := range board[0] {
		if r == StartRune {
			numBeams[i] = 1
		}
	}

	numSplits := 0
	for _, row := range board[1:] {
		nextNumBeams := make([]int, len(numBeams))

		for i, r := range row {
			if numBeams[i] == 0 {
				continue
			}

			if r == SplitterRune {
				nextNumBeams[i-1] += numBeams[i]
				nextNumBeams[i+1] += numBeams[i]

				numSplits += 1
			} else {
				nextNumBeams[i] += numBeams[i]
			}
		}

		numBeams = nextNumBeams

		// for i, n := range numBeams {
		// 	if row[i] == SplitterRune {
		// 		fmt.Print("^ ")
		// 	} else {
		// 		fmt.Printf("%1d ", n)
		// 	}
		// }
		// fmt.Println()

	}

	numTimelines := 0
	for _, n := range numBeams {
		numTimelines += n
	}

	fmt.Println("Splits   : ", numSplits)
	fmt.Println("Timelines: ", numTimelines)
}
