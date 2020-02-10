const Auction = artifacts.require("Auction");
const Item = artifacts.require("Item");


module.exports = function(deployer) {
  deployer.deploy(Auction);
  deployer.deploy(Item, "donut", 100);
};
