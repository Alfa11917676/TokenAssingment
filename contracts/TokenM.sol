// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenM is ERC20, Ownable {
    
    uint256 public maxSupply = 270000 ether;
    uint256 public maxPerTx = 10000 ether;
    uint256 public maxPerWallet = 100000 ether;
    address public usdt;
    mapping (address => uint256) public totalMinted;
    mapping(address => bool) public isKyc;

    constructor(address USDT) ERC20("TokenM", "TM") {
        usdt = USDT;
    }
    
    function decimals() public pure override returns (uint8) {
        return 18;
    }
    
    function mintUsingUSDT(address _to, uint256 amount) external {
        require(isKyc[msg.sender], "KYC not done");
        require(totalSupply()+amount<=maxSupply,"Not Enough Supply");
        require(amount<=maxPerTx,"Max amount per tx cap");
        require(balanceOf(_to)+amount<=maxPerWallet,"Max amount per waller cap");
        require(totalMinted[msg.sender]+amount<=maxPerWallet,"Max amount per waller cap" );
        totalMinted[msg.sender]+=amount;
        IERC20(usdt).transferFrom(msg.sender, address(this), amount);
        _mint(_to, amount);
    }
    
    function kyc(address _to) external onlyOwner {
        isKyc[_to] = true;
    }
}
