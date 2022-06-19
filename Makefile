# Based on https://github.com/abigger87/femplate

-include .env

# Clean the repo
clean  :; forge clean

# Install the Modules
install :; forge install

# Update Dependencies
update   :; forge update

# Builds
build  :; forge build

# Tests
tests   :; forge test --optimize --optimizer-runs 1000000 --use 0.6.12 -vv
