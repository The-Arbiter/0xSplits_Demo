// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "src/SplitMain.sol";

interface SplitsETHDistributor {
    /** @notice Distributes the ETH balance for split `split`
    *  @dev `accounts`, `percentAllocations`, and `distributorFee` are verified by hashing
    *  & comparing to the hash in storage associated with split `split`
    *  @param split Address of split to distribute balance for
    *  @param accounts Ordered, unique list of addresses with ownership in the split
    *  @param percentAllocations Percent allocations associated with each address
    *  @param distributorFee Keeper fee paid by split to cover gas costs of distribution
    *  @param distributorAddress Address to pay `distributorFee` to
    */
    function distributeETH(
        address split,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) external;
}


contract Contract{

    SplitMain splitter;
     

    /// @notice Calls distributeETH
    function callDistributeETH(
        address split,
        address[] calldata accounts,
        uint32[] calldata percentAllocations,
        uint32 distributorFee,
        address distributorAddress
    ) public{
        // Calls the splitter
        splitter.distributeETH(
            split,
            accounts,
            percentAllocations,
            distributorFee,
            distributorAddress
        );
        return;
    }

}
