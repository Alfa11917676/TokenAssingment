// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenM is ERC20 {
    
    uint256 public maxSupply = 1000000 ether;
    uint256 public maxPerTx = 10000 ether;
    uint256 public maxPerWallet = 100000 ether;
    address public usdt;
    mapping (address => uint256) public totalMinted;

    constructor(address USDT) ERC20("TokenM", "TM") {
        usdt = USDT;
    }
    
    function mint( uint256 amount) public {
        require(totalSupply()+amount<=maxSupply,"Not Enough Supply");
        require(amount<=maxPerTx,"Max amount per tx cap");
        require(balanceOf(msg.sender)+amount<=maxPerWallet,"Max amount per waller cap");
        _mint(msg.sender, amount);
    }
    
    function decimals() public pure override returns (uint8) {
        return 5;
    }
    
    function mintUsingUSDT(address _to, uint256 amount) external {
        require(totalSupply()+amount<=maxSupply,"Not Enough Supply");
        require(amount<=maxPerTx,"Max amount per tx cap");
        require(balanceOf(_to)+amount<=maxPerWallet,"Max amount per waller cap");
        require(totalMinted[msg.sender]+amount<=maxPerWallet,"Max amount per waller cap" );
        totalMinted[msg.sender]+=amount;
        IERC20(usdt).transferFrom(msg.sender, address(this), amount);
        _mint(_to, amount);
    }
}
