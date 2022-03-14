// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/access/Ownable.sol";

contract DownstreamERC20 is ERC20, Ownable {

    /// An ERC20 that requires you have a separate ERC20 (known as the "upstream")

    ERC20 private upstream;

    constructor(address upstream_) ERC20("Downstream Token", "DTKN") {
        upstream = ERC20(upstream_);
    }

    modifier hasUpstream(address to) {
        require(upstream.balanceOf(to) > 0);
        _;
    }

    function mint(address to, uint256 amount) public onlyOwner hasUpstream(to) {
        _mint(to, amount);
    }
}
