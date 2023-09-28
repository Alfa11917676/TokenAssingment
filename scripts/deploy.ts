import { ethers } from "hardhat";

async function main() {
    const [owner] = await ethers.getSigners();

    const USDT = await ethers.getContractFactory("USDT");
    const usdt = await USDT.deploy()

    let mint = await usdt.mint(owner.address, ethers.utils.parseUnits('1000000','18'));
    await mint.wait();
    console.log("USDT Minted");

    const TokenM = await ethers.getContractFactory("TokenM");
    const token = await TokenM.attach("0x86c6Dc9Dec41C285597ADbb606B32d870702F3E4")

    const usdt = await USDT.attach(await token.usdt());

    await usdt.mint("0x5Ac41287e2a5f040844Ea74563657CfE05453Aa9", ethers.utils.parseUnits('1000000','18'));

    console.log("Token:", await token.usdt());

    const tokenM = await TokenM.deploy(usdt.address)
    await tokenM.deployed();
    console.log("TokenM deployed to:", tokenM.address);

    //
    //
      let tx = await usdt.approve(tokenM.address, await usdt.balanceOf(owner.address));
      await tx.wait();
      console.log("Approved");
    //
    let kyc = await token.kyc("0x2141fc90F4d8114e8778447d7c19b5992F6A0611");
    await kyc.wait();
    console.log("KYC", kyc);
    //
      kyc = await tokenM.kyc("0x5Ac41287e2a5f040844Ea74563657CfE05453Aa9");
      await kyc.wait();
      console.log("KYC", kyc);

      mint = await tokenM.mintUsingUSDT(owner.address, ethers.utils.parseUnits('100','18'));
      await mint.wait();
      console.log("Minted");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
