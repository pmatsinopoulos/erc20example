// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    uint256 public initialSupply = 100_000_000 * 1e18;

    constructor() ERC20("OurToken", "OTK") {
        _mint(msg.sender, initialSupply);
    }
}
