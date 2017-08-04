var usingOraclize = artifacts.require("./usingOraclize.sol");
var KYCPolyMath = artifacts.require("./KYCPolyMath.sol");

module.exports = function(deployer) {
  deployer.deploy(usingOraclize);
  deployer.link(usingOraclize, KYCPolyMath);
  deployer.deploy(KYCPolyMath);
};
