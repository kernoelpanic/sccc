pragma solidity ^0.4.25;

contract Stats {
    uint256 public initBlkNumber;
    uint256 public lastBlkNumber;

    uint256 public initBlkTimestamp;
    uint256 public lastBlkTimestamp;

    address public initSender;
    address public lastSender;

    address public initOrigin;
    address public lastOrigin;

    uint256 public initValue;
    uint256 public lastValue;

    uint256 public receivedValue;

    constructor() public payable {
        initBlkNumber = block.number;
        initBlkTimestamp = block.timestamp;
        initSender = msg.sender;
        initOrigin = tx.origin;
        initValue = msg.value;
    }

    function update() public payable returns (uint256,uint256,address,address,uint256) {
        lastBlkNumber = block.number;
        lastBlkTimestamp = block.timestamp;
        lastSender = msg.sender;
        lastOrigin = tx.origin;
        lastValue = msg.value;
        receivedValue += lastValue;
        return (lastBlkNumber,
                lastBlkTimestamp,
                lastSender,
                lastOrigin,
                lastValue) ;
    }

    function fundsCheck() view public returns (bool) {
        if (address(this).balance != receivedValue) {
          return false;
        } else {
          return true;
        }
    }

    function senderCheck() view public returns (bool) {
        if (lastSender != lastOrigin) {
          return false;
        } else {
          return true;
        }
    }
}
