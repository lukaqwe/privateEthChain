pragma solidity^0.6.1;

contract Greet{
  bytes32 public message;

    constructor() public {
    }

    function setMsg(bytes32  another) public {
      message = another;
    }

    function greet() public view returns (bytes32){
      return message;
    }

    function add(uint x, uint y) public pure returns (uint){
      return  x+y;
    }
}
