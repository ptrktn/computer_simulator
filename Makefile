.PHONY: all
all: test

# Expected output:
# 1009
# 1010
.PHONY: test
test:
	# Run unit tests
	./tc_computer_simulator.rb
	# Two lines of output is expected
	test "2" = "$(shell ./computer_simulator.rb | wc -l)"
	# Check the output
	./computer_simulator.rb | grep -Pz '^1009\n1010'

.PHONY: debug
debug:
	DEBUG=1 ./computer_simulator.rb
