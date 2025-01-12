// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {Swap} from "../src/SingleSwap.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

// Mock ERC20 token for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

// Mock Swap Router implementation
contract MockSwapRouter is ISwapRouter {
    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        override
        returns (uint256 amountOut)
    {
        return params.amountIn * 2; // Mock doubling input as output
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        payable
        override
        returns (uint256 amountIn)
    {
        return params.amountOut / 2; // Mock halving output as input
    }

    function exactInput(ExactInputParams calldata) external payable override returns (uint256) {
        revert("Not implemented");
    }

    function exactOutput(ExactOutputParams calldata) external payable override returns (uint256) {
        revert("Not implemented");
    }

    function uniswapV3SwapCallback(
        int256,
        int256,
        bytes calldata
    ) external pure override {
        revert("Not implemented");
    }
}

// Concrete implementation of Swap for testing purposes
abstract contract TestableSwap is Swap {
    constructor(
        ISwapRouter _swapRouter,
        uint24 _defaultPoolFee
    ) Swap(_swapRouter, _defaultPoolFee) {}
}



// abstract contract SwapTest is Test {
//     TestableSwap public swap;
//     MockERC20 public tokenA;
//     MockERC20 public tokenB;
//     MockSwapRouter public mockRouter;

//     address public user = address(1);

//     function setUp() public {
//     // Deploy mock tokens and router
//     tokenA = new MockERC20("Token A", "TKA");
//     tokenB = new MockERC20("Token B", "TKB");
    
//     mockRouter = new MockSwapRouter();
    
//     // Deploy TestableSwap with mock router, default pool fee, and owner address
//     swap = new TestableSwap(mockRouter, 3000);

//     // Mint tokens to user for testing
//     tokenA.mint(user, 1000 ether);

//     vm.label(user, "User");
//     vm.label(address(tokenA), "Token A");
//     vm.label(address(tokenB), "Token B");
// }
//}