const Token = artifacts.require('Token.sol');
const HTLC_A = artifacts.require('HTLC_A.sol');
const HTLC_B = artifacts.require('HTLC_B.sol');

module.exports = async function (deployer, network, addresses) {
  const [alice, bob] = addresses;      

  if(network === 'kovan') {
    await deployer.deploy(Token, 'Token A', 'TKNA', {from:  alice});
    const tokenA = await Token.deployed();
    await deployer.deploy(HTLC_A, bob, tokenA.address, 1, {from: alice});
    const htlc_a = await HTLC_A.deployed();
    await tokenA.approve(htlc_a.address, 1, {from: alice});
    await htlc_a.fund({from: alice});
  }
  if(network === 'binanceTestnet') {
    await deployer.deploy(Token, 'Token B', 'TKNB', {from: bob});
    const tokenB = await Token.deployed();
    await deployer.deploy(HTLC_B, alice, tokenB.address, 1, {from: bob});
    const htlc_b = await HTLC_B.deployed();
    await tokenB.approve(htlc_b.address, 1, {from: bob});
    await htlc_b.fund({from: bob});
  }
};

