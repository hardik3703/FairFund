RPC_URL := 127.0.0.1:8545
VERBOSITY := -vvvv
BROADCAST := --broadcast
LEGACY := --legacy

FORGE_SCRIPT := forge script


deploy-mock-fair-fund-v1:
	$(FORGE_SCRIPT) script/mocks/DeployMockFairFund.s.sol:DeployMockFairFund --rpc-url $(RPC_URL) $(VERBOSITY) $(BROADCAST) $(LEGACY)

deploy-mock-erc20-v1:
	$(FORGE_SCRIPT) script/mocks/DeployMockERC20.s.sol:DeployMockERC20 --rpc-url $(RPC_URL) $(VERBOSITY) $(BROADCAST) $(LEGACY)


dmfv1: deploy-mock-fair-fund-v1
dmev1: deploy-mock-erc20-v1

mock-all-v1: deploy-mock-fair-fund-v1 deploy-mock-erc20-v1

help:
	@echo "Available targets:"
	@echo "  deploy-mock-fair-fund-v1 (dmfv1)  : Deploy FairFund contract"
	@echo "  deploy-mock-erc20-v1 (dmev1)      : Deploy MockERC20 contract"
	@echo "  mock-all-v1                       : Deploy both contracts to anvil testnet"
	@echo "  help                              : Show this help message"

.PHONY: deploy-mock-fair-fund-v1 deploy-mock-erc20-v1 deploy-fair-fund-v1 dmf-v1 dme-v1 help