//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract eventManagement{
    using Counters for Counters.Counter;
    Counters.Counter private eventId;
    Counters.Counter private registrationId;
    
    address EventNFTAddr =0xebf93A28aA931fBE896E10A2da5634ED13B3fC51;

    struct Event{
        string title;
        string host;
        address organizer;
        string date;
        uint regCommenceDate;
        uint regEndDate;
        uint numberOfRegistrantsRequired;
        uint registrationAmount;
        uint EventId;
        bool registrationBegun;
        mapping (address => bool) registered;
        mapping (address => bool) joined;
    }

    mapping (uint => Event) public eventTrack;


    function haveNFT() internal {
        require(ERC721(EventNFTAddr).balanceOf(msg.sender) > 0, "You need to have the event NFT to register for this event.");
    }

    function regPayment(uint _EventId) internal {
        Event storage e = eventTrack[_EventId];
        uint regAmount = e.registrationAmount;
        require(msg.value == regAmount, "Required amount for registration not met");
    }

    
    function setUpEvent(string memory eventTitle, string memory eventHost, string memory eventDate, 
    uint registrationBegins, uint registrationEnds, uint expectedRegistrants, uint regAmount) public {
        eventId.increment();
        uint _eventId = eventId.current();
        Event storage e = eventTrack[_eventId];
        e.title  = eventTitle;
        e.host = eventHost;
        e.organizer = msg.sender;
        e.date = eventDate;
        e.regCommenceDate = registrationBegins;
        e.regEndDate = registrationEnds;
        e.numberOfRegistrantsRequired = expectedRegistrants;
        e.registrationAmount = regAmount;
        e.EventId = _eventId;
    }

    function commenceRegistration (uint _EventId) public {
        Event storage e = eventTrack[_EventId];
        address Organizer = e.organizer;
        uint regBeginDate = e.regCommenceDate;
        require(msg.sender == Organizer, "Only the Organizer can commence registration");
        require(block.timestamp <= regBeginDate, "It's not commence date yet");
        e.registrationBegun = true;
    }

    function regStatus(uint _EventId) internal {
        Event storage e = eventTrack[_EventId];
        require(e.registrationBegun == true, "Registration has not commenced");
    }

     function checkRegDateStatus(uint _EventId) internal {
        Event storage e = eventTrack[_EventId];
        uint endDate = e.regEndDate;
        require(endDate < block.timestamp, "Registration ended");
    }

    function setSenderRegStatus(uint _EventId) internal{
        Event storage e = eventTrack[_EventId];
        e.registered[msg.sender] = true;
    }

    function registerForEvent(uint _EventId) public payable {
        haveNFT();
        regStatus(_EventId);
        checkRegDateStatus(_EventId);
        regPayment(_EventId);
        setSenderRegStatus(_EventId);

    }

    function joinEvent(uint _EventId) public {
        Event storage e = eventTrack[_EventId];
        require(e.registered[msg.sender] == true, "You did not register for this event.");
        e.joined[msg.sender] = true;
    }
}