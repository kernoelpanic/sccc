pragma solidity ^0.5.12;

contract Greeter {
    string public greeting;
    uint256 public greetbit;

    //Old constructor syntax, function name same as contract name:
    //function Greeter() public {
    //new constructor syntax:
    constructor() public {
        greeting = 'Hello';
    }

    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    function greet() view public returns (string memory) {
        return greeting;
    }

    function setGreetbit(uint256 _bit) public {
        greetbit = _bit;
    }

    function getGreetbit() view public returns (uint256) {
        return greetbit; 
    }

    function() external payable{
        greetbit = greetbit ^ 1;
    }
}
