SRC=main.cpp
DEST=main

$(DEST): $(SRC)
	g++ -o $(DEST) $(SRC) -std=c++11

.PHONY: run-example
run-example: $(DEST)
	cat input-example.txt | ./$(DEST) 10 3

.PHONY: run
run: $(DEST)
	cat input.txt | ./$(DEST) 1000 3
