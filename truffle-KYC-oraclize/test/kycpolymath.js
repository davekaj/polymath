var KYCPolyMath = artifacts.require("./KYCPolyMath.sol");

contract('KYCPolyMath', function(accounts) {//accounts is needed to get the array of accoutns on the testRPC


    it("Should confirm that one user struct is added to the mapping userKYCInfoArray when a new user", function(){
        var kyc;
        var result;
        
        return KYCPolyMath.deployed().then(function(instance){
            kyc = instance;
            return kyc.applyForKYC("David", "Kajpust", "1992/03/23", "Canadian", {from:accounts[0], gas: 500000, value: web3.toWei(0.01, "ether")});
        }).then(function(){
            return kyc.getter_User_Applications.call();
        }).then(function(usersEntered){
            result = usersEntered;
            console.log(accounts[0]);
            assert.equal(result, 1, "One person applied, and that struct should be in the dynamic array, giving length 1");
        });
    });






    it("should return true or false, depending on what API returns", function(done){
        var kyc;
        var result;

        KYCPolyMath.deployed().then(function(instance){
            kyc = instance;
            return;
        }).then(function(){
            return new Promise(resolve => setTimeout(resolve, 20000));
        }).then(function(){
            return kyc.verifyFromOutside.call(accounts[0]);
        }).then(function(value){
            result = value;
            assert.equal(result, true, "If true from API true, if false, fail");
   //         assert.equal(result, "true", "If true from API true, if false, fail");

            console.log(result);
            done();
        });
    });

        it("Should return first name", function(){
        var kyc;
        var result;
        
        return KYCPolyMath.deployed().then(function(instance){
            kyc = instance;
            return kyc.applyForKYC("David", "Kajpust", "1992/03/23", "Canadian", {from:accounts[0], gas: 500000, value: web3.toWei(0.01, "ether")});
        }).then(function(){
            return kyc.getter_User_Array_Info.call(0);
        }).then(function(usersEntered){
            result = usersEntered;
            console.log(accounts[0]);
            assert.equal(result, true, "name is david ");
   //         assert.equal(result, "true", "name is david ");

   //this works. so its the mapping that sucks. the stuct is ok. 
            
        });
    });
/*






    it("should just assert that 4 = 4 to test it is working", function(){
        //setTimeout(()=>{}, 15000);
        return WolframAlpha.deployed().then(function(instance){
            return instance.getAnswer.call();
        }).then(function(theAnswer){
            assert.equal(theAnswer, 4, "two plus two hopefully equals 4");
        });
    });*/

})