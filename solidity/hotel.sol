// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Hostel{
    
    address payable tenant;
    address payable landlord;

    uint public no_of_rooms = 0;
    uint public no_of_aggrement = 0;
    uint public no_of_rent = 0;

    struct Room{
        uint roomid;
        uint aggrement;
        string roomname;
        string roomaddress;
        uint rent_per_month;
        uint securityDeposit;
        uint timestamp;
        bool vacant;
        address payable landlord;
        address payable currentTenant;
    } 
    
    mapping(uint => Room) public Room_by_No;

    struct RoomAgreement{
        uint roomid;
        uint aggrementid;
        string Roomname;
        string Roomaddress;
        uint rent_per_month;
        uint securityDeposit;
        uint lockinPeriod;
        uint timestamp;
        address payable tenantAddress;
        address payable landlordAdress;
    }
    
    mapping(uint => RoomAgreement) public RoomAgreement_by_No;

    struct Rent{
        uint rentno;
        uint roomid;
        uint agreementid;
        string Roomname;  
        string RoomAddress;  
        uint rent_per_month;
        uint timestamp;
        address payable tenantAddress;
        address payable landlordAddress;
    }
   mapping(uint => Rent) public Rent_by_No;

   modifier onlyLandLord(uint _index) {
    require(msg.sender == Room_by_No[_index].landlord,"Only landlord can access this");
    _;
     
   }
   modifier notLandLord(uint _index) {
    require(msg.sender == Room_by_No[_index].landlord,"Only tenant can access this");
    _;
   }
   modifier OnlywhileVacant(uint _index){
     require(Room_by_No[_index].vacant == true,"Room is currently occupied");
    _;
   }
   modifier enoughRent(uint _index){
    require(msg.value >= uint(Room_by_No[_index].rent_per_month),"Not enough ether in your wallet");
    _;
   }
   modifier enoughAgreementfee(uint _index){
    require(msg.value >= uint(Room_by_No[_index].rent_per_month) + uint(Room_by_No[_index].securityDeposit),"Not enough ether in your wallet for Agreement fees");
    _;
   }
   modifier sameTenant(uint _index){
    require(msg.sender == Room_by_No[_index].currentTenant,"No previous Agreement with you and Landlord");
    _;
   }
   modifier AgreementTimesLeft(uint _index){
    uint  _AgreementNo = Room_by_No[_index].aggrement;
    uint time = RoomAgreement_by_No[_AgreementNo].timestamp + RoomAgreement_by_No[_AgreementNo].lockinPeriod;
    require(block.timestamp < time,"Agreement already ended");
    _;
   }
   modifier AgreementTimesUp(uint _index){
    uint  _AgreementNo = Room_by_No[_index].aggrement;
    uint time = RoomAgreement_by_No[_AgreementNo].timestamp + RoomAgreement_by_No[_AgreementNo].lockinPeriod;
    require(block.timestamp > time,"Agreement already ended");
    _;
   }
   modifier RentTimesUp(uint _index) {
    uint time = Room_by_No[_index].timestamp + 30 days;
    require(block.timestamp >= time, "Time left to pay rent");
    _;
   }
   function addRoom(string memory _roomname,string memory _roomaddress,uint rent_per_month,uint securityDeposit){
    require(msg.sender != address(0));
    no_of_rooms ++;
    bool _vacancy = true;
    Room_by_No[no_of_rooms] = Room(no_of_rooms,0,_roomname,_roomaddress,_rentcost,_securityDeposit,0,)
}