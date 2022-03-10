import { expect } from "chai";
import { Contract, Signer } from "ethers";
import { ethers } from "hardhat";

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});


describe("Protocol", function () {
  //Contract Instances
  let avatarContract: Contract;
  let configContract: Contract;
  //Addresses
  let owner: Signer;
  let admin: Signer;
  let tester: Signer;
  let addrs: Signer[];


  before(async function () {
      //Deploy Avatar
      const ConfigContract = await ethers.getContractFactory("Config");
      configContract = await ConfigContract.deploy();

      //Deploy Avatar
      const AvatarContract = await ethers.getContractFactory("AvatarNFT");
      avatarContract = await AvatarContract.deploy(configContract.address);

      //Populate Accounts
      [owner, admin, tester, ...addrs] = await ethers.getSigners();
  })

  
  describe("Config", function () {

    it("Should be owned by deployer", async function () {
      expect(await configContract.owner()).to.equal(await owner.getAddress());
    });

  });
  describe("Avatar", function () {

    it("Should have Config", async function () {      
      expect(await avatarContract.getConfig()).to.equal(configContract.address);
    });

    it("Should inherit owner", async function () {
      expect(await avatarContract.owner()).to.equal(await owner.getAddress());
    });

    //Should Fail to transfer -- "Sorry, Assets are non-transferable"

  });

});
