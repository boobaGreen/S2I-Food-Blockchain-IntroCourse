// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundRaiser {
    // VARIABLE STATEMENTS SECTION ----------
    address payable public owner; 
    uint public totalRaisedWei; 
    uint public totalParticipants; 
    uint public totalDonation; 
    uint public targetEth; 
    bool public open; 
    bool public achieved; 
    mapping (address => uint) nDonationForAddress;

    // CONSTRUCTOR ---------
    constructor(uint256 _targetEth) payable {
        owner = payable(msg.sender); 
        totalRaisedWei = 0;
        totalParticipants = 0; 
        open = true; 
        targetEth = _targetEth; 
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    // MODIFER SECTION -----------
    modifier onlyWhileOpen() {
        require(
            open == true,
            "Fundraiser already Closed !!! thank you very much anyway , God bless you "
        );
        _;
    }
    modifier onlyWhileClose() {
        require(
            open == false,
            "Fundraiser is Open !!! close manually(only owner) or reach the target before withdraw fund "
        );
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner");
        _;
    }
    //FUNCTION SECTION 
    function closeFundRaising() public onlyOwner onlyWhileOpen {
        open = false;
    }

    function getBalanceWei() public view returns (uint) {
        return address(this).balance;
    }

    function getAchieved() public view returns (bool) {
        return
            (totalRaisedWei >= targetEth * 1000000000000000000) ? true : false;
    }

    function makeDonation() external payable onlyWhileOpen {
        (bool success, ) = address(this).call{value: msg.value}("");
        require(success, "call failed when send fund"); 
        totalRaisedWei += msg.value; 
        totalDonation += 1; 
        // bool alreadyExist = false; 
        if (getAchieved()) {
            achieved = true; 
            open = false; 
        }
         if (nDonationForAddress[msg.sender]==0) {
            // addressList.push(msg.sender); 
            totalParticipants +=1; 
        }
        nDonationForAddress[msg.sender]+=1;
    }

    function withdrawFund() external payable onlyWhileClose onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "call failed when withdraw");
    }
}
