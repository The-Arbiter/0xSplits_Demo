// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Contract.sol";
import "src/SplitMain.sol";

contract ContractTest is Test {

    Contract mainContract;
    SplitMain splitter;

    function setUp() public {
        // Set up the splitter 
        splitter = new SplitMain();
        // Set up the contract
        mainContract = new Contract(splitter);
        
    }

    /// @dev helper for other tests
    function _fuzzTestRestrictions(address fuzzAddress_) internal {
        // Exclude VM address
        vm.assume(fuzzAddress_ != address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D)); // VM address
        vm.assume(fuzzAddress_ != address(0xCe71065D4017F316EC606Fe4422e11eB2c47c246));
        vm.assume(fuzzAddress_ != address(this)); // This contract
    }

    /// @dev Helper taken from 0xSplits contract
    function _getSum(uint32[] memory numbers) internal pure returns (uint32 sum) {
        // overflow should be impossible in for-loop index
        uint256 numbersLength = numbers.length;
        for (uint256 i = 0; i < numbersLength; ) {
        sum += numbers[i];
        unchecked {
            // overflow should be impossible in for-loop index
            ++i;
        }
        }
    }

    // Tests a basic split between two parties
    function testBasicSplit() public {
        
        // STEP 1 - Deploy an immutable splitter proxy

        uint256 amount_ = 10 ether;

        // Set up arrays of addresses and percentages
        address[] memory addresses = new address[](2);
        uint32[] memory percentages = new uint32[](2);
       
        addresses[0] = address(0x1111); // Party 1
        percentages[0] = 1e6 * 0.6666;
        addresses[1] = address(0x2222); // Party 2
        percentages[1] = 1e6 * 0.3334;

        // Ensure that the sum of the percentages is 100%
        vm.assume(_getSum(percentages) == 1e6);

        // Create a deterministic splitter
        address splitterAddress = splitter.createSplit(
            addresses,
            percentages,
            0, // Distributor fee assumed to be zero
            address(0) // Using CREATE2 (deterministic splits) means that the controller must be the zero address
        );

        console2.log("Created splitter address is ",splitterAddress);

        // STEP 2 - Send in some ETH

        vm.prank(address(0));
        vm.deal(address(0), amount_);
        console2.log("Sending the splitter ",amount_);
        payable(address(splitterAddress)).transfer(amount_);

        // STEP 3 - Update the values in the splitter

        mainContract.callDistributeETH(
            splitterAddress,
            addresses,
            percentages,
            0,
            address(0)
        );



    }
}
