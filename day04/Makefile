DST=main
SRC=main.hs

$(DST): $(SRC)
	ghc -o $(DST) $(SRC)

run-example: $(DST)
	cat input-example.txt | ./$(DST)

run: $(DST)
	cat input.txt | ./$(DST)
