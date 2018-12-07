pragma solidity ^0.4.25;

contract Greeter {
    string public greeting;
    uint256 public greetbit;

    //Old constructor syntax, function name same as contract name:
    //function Greeter() public {
    //new constructor syntax:
    constructor() public {
        greeting = 'Hello';
    }

    function setGreeting(string _greeting) public {
        greeting = _greeting;
    }

    function greet() view public returns (string) {
        return greeting;
    }

    function setGreetbit(uint256 bit) public {
        greetbit = bit;
    }

    function greetbit() view public returns (uint256) {
        return greetbit; 
    }

    function() public payable{
        greetbit = greetbit ^ 1;
    }

}
