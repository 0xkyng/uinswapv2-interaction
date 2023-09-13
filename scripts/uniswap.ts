import { ethers } from "hardhat";

async function main() {
  const uniswapAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"
  const uniswapV2 = await ethers.getContractAt("IUniswap", uniswapAddress)

  const uniToken = "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984"
  const UNI = await ethers.getContractAt("IERC20", uniToken)

  const WETHAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
  const holder = "0x20bB82F2Db6FF52b42c60cE79cDE4C7094Ce133F"

  const impersonter = await ethers.getImpersonatedSigner(holder)

  const uniAmountDesired = ethers.parseEther("20")
  const amountuniMin = ethers.parseEther("0")
  const amountETHMin = ethers.parseEther("0")
  const to = "0x9cDF5ce3c9Ea71ECC8fb7C3A17ed7B6c74F9C5F0"
  const currentTimestampInSeconds = Math.round(Date.now() / 100)
  const deadline = currentTimestampInSeconds + 86400
  const value = ethers.parseEther("0.2")

  await UNI.connect(impersonter).approve(uniswapV2, ethers.parseEther("500"))

  await uniswapV2.connect(impersonter).addLiquidityETH(uniToken, uniAmountDesired, amountuniMin, amountETHMin, to, deadline, {value: value})


 // Removing liquidity

  const uniswapV2Factory = await ethers.getContractAt("IUniswapV2Factory", await uniswapV2.factory())
// const uniswapFactoryAdddress = "0x5c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f"

  const pair = await uniswapV2Factory.connect(impersonter).getPair(WETHAddress, UNI)
  const liquidity = await ethers.getContractAt("IERC20", pair)

  liquidity.connect(impersonter).approve(uniswapV2, ethers.parseEther("20"))
  

  const removeLiquidity = await uniswapV2.removeLiquidityETH(uniToken, uniAmountDesired, amountuniMin, amountETHMin, to, deadline)
  await removeLiquidity.wait();


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
