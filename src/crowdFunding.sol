// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;




contract CrowdFunding{

    ////////errors//////
    error CrowdFunding_OnlyOwnerCanCallThisFunction();
    error CrowdFunding_CampaignIsStillGoingOn();
    error CrowdFunding_CampaignHasNotFailed();
    error CrowdFunding_CampaignIsOver();
    error CrowdFunding_YouShouldSendSomeEtherum();
    error CrowdFunding_WithdrawFailed();
    error CrowdFunding_RefundFailed();
    error CrowdFunding_YouHaveRefundedBefore(); 
    error CrowdFunding_YouhaveParticipateBefore();



    ////events/// 
    event Participated(address indexed user,uint256 indexed Amount);
    event Refunded(address indexed user,uint256 indexed Amount);


    /////variables/////
    address private immutable OWNER;
    uint256 private constant DEADLINE= 86400;
    uint256 private immutable INITIALTIME;
    uint256 private constant DECIMAlS=10**18;
    uint256 private constant GOAL_AMOUNT=10*DECIMAlS;
    uint256 private RaisedFunds=0;



    ////arrays//// 
    mapping (address => uint256) UserToFund;
    address[] funders;



    constructor(){
        INITIALTIME=block.timestamp;
        OWNER=msg.sender;
    }

    
    /////modifiers////// 

    modifier OnlyOwner {
        if (msg.sender != OWNER){
            revert CrowdFunding_OnlyOwnerCanCallThisFunction();            
        }  
        _;     
    }
    modifier DeadLine {
        if (block.timestamp < INITIALTIME+DEADLINE){
            revert CrowdFunding_CampaignIsStillGoingOn();
        }
        _;
    }
    modifier IfFailed {       
        if (block.timestamp >= INITIALTIME+DEADLINE){
            if (GOAL_AMOUNT < RaisedFunds){
            revert CrowdFunding_CampaignHasNotFailed();
            }
        }
        _;
    }


    /////functions/////
    function participate()public payable{
        if (block.timestamp >= INITIALTIME+DEADLINE){
            revert CrowdFunding_CampaignIsOver();
        }
        if (msg.value == 0){
            revert CrowdFunding_YouShouldSendSomeEtherum();
        }
        if(UserToFund[msg.sender] != 0){
            revert CrowdFunding_YouhaveParticipateBefore();
        }
         UserToFund[msg.sender] += msg.value;
         RaisedFunds += msg.value;
         funders.push(msg.sender);
         emit Participated(msg.sender,msg.value);

    }
    
    function refund()public IfFailed{

        if (UserToFund[msg.sender] == 0){
            revert CrowdFunding_YouHaveRefundedBefore(); 
        }   
        (bool Success, ) = payable(msg.sender).call{value: UserToFund[msg.sender]}("");
            if (!Success){
            revert CrowdFunding_RefundFailed();
            } 
        UserToFund[msg.sender]=0;
        funders = new address[](0);

    }


    function withdraw()public OnlyOwner DeadLine{
        
        funders = new address[](0);
        (bool Success, ) = payable(OWNER).call{value: address(this).balance}("");
        if (!Success){
            revert CrowdFunding_WithdrawFailed();
        }
    } 

    function RefundAll()public OnlyOwner IfFailed{
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            (bool Success, ) = payable(funders[funderIndex]).call{value: UserToFund[funders[funderIndex]]}("");
        if (!Success){
            revert CrowdFunding_RefundFailed();
        }
        emit Refunded(funders[funderIndex],UserToFund[funders[funderIndex]]);
        UserToFund[funders[funderIndex]]=0;       
        }
    }




    //////accepting ether/////
    receive()external payable{
        participate();
    }
    fallback()external payable{
        participate();
    }

    ///////getter functions///////
    function GetOwner()public view returns (address){
        return OWNER;
    }
    function GetFunder(uint256 index)public view returns(address){
        return funders[index];
    }
    function getAmountAUserFounded(address funder)public view returns (uint256){
        return UserToFund[funder];
    }
    function getDecimal()public pure returns (uint256){
        return DECIMAlS;
    }
    function getInitialTime()public view returns (uint256){
        return INITIALTIME;
    }
    function getDeadLine()public pure returns (uint256){
        return DEADLINE;
    }
    function getRaisedAmount()public view returns(uint256){
        return RaisedFunds;
    }



}