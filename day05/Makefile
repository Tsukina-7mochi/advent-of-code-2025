SRC=main.c
DEST=main

$(DEST): $(SRC)
	cc -o $(DEST) $(SRC)

.PHONY: run-example
run-example: $(DEST)
	cat input-example.txt | ./$(DEST)

.PHONY: run
run: $(DEST)
	cat input.txt | ./$(DEST)
