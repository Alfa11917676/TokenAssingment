// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CoinM is ERC20, Ownable {
    IERC20 public tokenM;
    IERC20 public usdt;
    uint256 public maxPerWallet = 100000 ether;
    
    // Let's assume exchange rate of 1 TokenM = 100 CoinM
    uint256 public priceOfTokenMPerCoinM = 100 ether;
    uint256 public priceOfTokenPerUSDT = 1 ether;
    mapping (address => uint256) public totalMinted;
    
    constructor(address _tokenM, address _usdt) ERC20("CoinM", "CM") {
        tokenM = IERC20(_tokenM);
        usdt = IERC20(_usdt);
    }
    
    //Mint CoinM using TokenM and USDT
    //Max Mint Per User is 100000 TokenM
    //Max Mint Per Transaction is 10000 TokenM
    function mint(address to, uint256 amount, bool useCoinM) public  {
        require(totalMinted[msg.sender]+amount<=maxPerWallet,"Max amount per waller cap" );
        totalMinted[msg.sender]+=amount;
        IERC20 tokenToUse = useCoinM ? tokenM : usdt;
        uint256 chargeableAmount = useCoinM ? amount * priceOfTokenMPerCoinM : amount * priceOfTokenPerUSDT;
        tokenToUse.transferFrom(msg.sender, address(this), chargeableAmount);
        _mint(to, amount);
    }
    
    function decimals() public pure override returns (uint8) {
        return 5;
    }
    
    function withdrawTokens() external onlyOwner {
        tokenM.transfer(msg.sender, tokenM.balanceOf(address(this)));
        usdt.transfer(msg.sender, usdt.balanceOf(address(this)));
    }
    
}
