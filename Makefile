.PHONY: all build deploy

deploy:
	forge script -vvvvv script/DeployOurToken.s.sol:DeployOurToken --broadcast --rpc-url $(RPC_URL) --account ANVIL_PRIVATE_KEY_FIRST_ACCOUNT
