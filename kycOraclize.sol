/*
   Diesel Price Peg

   This contract keeps in storage a reference
   to the Diesel Price in USD
*/


pragma solidity ^0.4.12;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract KYCPolyMath is usingOraclize {
    
    
    modifier noEther {if (msg.value > 0) throw; _; }
    modifier onlyOwner {if (msg.sender != owner) throw; _; }
    modifier onlyOraclize {if (msg.sender != oraclize_cbAddress()) throw; _; }
	modifier onlyInState (uint _entryID, stateOfEntry _state) {
		entryInformation instance = entries[_entryID];
		if (instance.state != _state) throw;
		_;
	}
    
    
    /* this is more advanced. it would allow for certain parts of the contract to be called only at certain points. like if it has not been approved, you cant call a function that is only for approval
    00 initiated = person has applied, and their info is populated, it is yet to get sent to oracle
    01 applied = it has been put through to the oracle
    02 approved = the oracle returned correctly and it approved
    03 rejected = the oracle returned correctly and kyc got rejected
    04 unkown = the oracle returned and could not figure figure out if the KYC is approved
    05 invalid = something went wrong with the oracle, either bad data, or oracle failure
    */
    enum stateOfKYC {Initiated, Applied, Approved, Rejected, Unknown, Invalid }; //00 01 02 03 04 05

    //this itself should just be address and true or ANYTHING ELSE THAT IS FALSE. will add later 
    

    event newOraclizeQuery(string description);
    event newKYCResults(string KYCResult);
    event LOG_OraclizeCall(uint userID, uint queryID, string oraclizeURL);
    event LOG_OraclizeCallback(uint userID, bytes _queryID, string result); //bytes _proof if wanted
    
    address public owner;
    uint constant oraclizeGas = 500000;
    uint constant temporaryURLToReplaceKYC = ["json(https://polymath-network.herokuapp.com/kyc).valid","{"name": "testing"}"];
    
    
    
    //this might be better stored in a seperate Database contract, but here and simple for now
    userKYCInformation[] public userKYCInfoArray;

    mapping (address => bool) public KYCVerification; //quick lookup reference if an address has been approved
    mapping  (address => uint) public KYC_ID; // a lookup to help grab the user info when needed
    mappipng (bytes32 => oraclizeCallback) public oraclizeCallbacks; //this is needed in order to relate the query ID back to the user ID 
    
    //mapping(bytes32 => oraclizeCallback) public oraclizeCallbacks;


    struct userKYCInformation{
        //unique public addresss of entry
        address ethereumPubKey;
        bool kycApproved;
        stateOfRequest state;
        string firstName;
        string lastName;
        string dateOfBirth;
        string citizenship;
        //bytes proof;
        //maybe in here would be some cryptographyically secure stuff so it doesnt get tossed over the net the guys information
    }
    
    struct companyInformation {
        string companyName;
        string countryOfOrigin;
    }
    
    struct buyTokens {
        //some stuff in here to let people purchase the token. prob dont need this yet 
    }
    
    //yes this sturct is needed, as the oraczlie query ID is the only way to link the callback directly back to the user we want
    //only has userID for now, but it could be expanded, this is why it is struct 
    struct oraclizeCallback{
        uint userID;
    }
    
    
    


    //constructor Function
    function KYCPolyMath() {
        owner = msg.sender;
        
    }


    //this one is done in order to check the data you get back, and then see if the verification is good and will give true or false and update the mapping
    //but is it checking for USA, canada, etc. ?
    
    
    //either this has to be payable or verifyKYC does, for the oraczlie query. or the contract needs ether 
    function applyForKYC (address _ethPubKey, string _first, string _last, string _birthDate, string _citizenship) payable {
        uint userID = userKYCInfoArray.legnth++; 
        
        KYC_ID[msg.sender] = userID; //
        KYCVerifiation[msg.sender] = false; //start off the person as false for approval for lookup
        userKYCInformation instance = userKYCInfoArray[userID]; //filling in the dynamic array evertime a new person tries to get KYC
        
        
        instance.ethereumPubKey = msg.sender
        instance.kycApproved = false;
        instance.state = stateOfKYC.Initiated;
        instance.firstName = _first;
        instance.lastName = _last;
        instance.dateOfBirth = _birthDate;
        instance.citizenship = _citizenship;
        
        
        //parseStringForOraclize();
        //will pass temp string for now
        verifyKYC(temporaryURLToReplaceKYC, userID);
        
    }
    
    /*
    function parseStringForOraclize () returns (string) {
       this function would parse the string that needs to be sent over oraclize so the API would work 
       
       return parsedString
    }*/
    
    function verifyKYC (string _parsedURLData, uint userID) payable internal returns (bool){
        newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        bytes32 queryID = oraclize_query("URL", _parsedURLData); //this is done in order to save the queryID, and link it back to userID
        
        oraclizeCallbacks[queryID] = oraclizeCallback(userID);
        
        LOG_OraclizeCall(userID, queryID, _parsedURLData);
    }
    
    function updateKYC (string _oracleResult) internal {
        userKYCInformation instance = 
        
        //so i want the message.sender or that message.senders int location in the dynamic array
        
        userKYCInfoArray[KYC_ID].kycApproved = _oracleResult;
        
        address user = //get from KYC_ID and dyn array
        
        KYCVerification[user] = _oracleResult
        
    }


    function __callback(bytes32 _queryID, string result) onlyOraclize {
        oraclizeCallback memory instance = oraclizeCallbacks[_queryID]
        
        uint userID = instance.userID;
        
        if (result = "true") 
            userKYCInfoArray[userID].kycApproved = true;
            KYCVerification[userKYCInfoArray[userID].ethereumPubKey] = true
            
            
        if (result = "false")
            userKYCInfoArray[userID].kycApproved = false;
            KYCVerification[userKYCInfoArray[userID].ethereumPubKey] = false

        newKYCResults(result);
        
        
        
        

    }
    
    function verifyFromOutside external () {
        //this function will just look at the mapping and return true or false. easy call after
        //it actually gets approved and you dont want to run through everything again 
    }
    
    function {}
    
}



