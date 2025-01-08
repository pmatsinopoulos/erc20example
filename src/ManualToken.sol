// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ManualToken {
    mapping(address => uint256) private s_balances;

    string public name = "Manual Token";

    event Transfer(address indexed from, address indexed to, uint256 amount);

    error ManualToken__NotEnoughBalanceError(
        address from,
        uint256 balance,
        uint256 amount
    );

    function totalSupply() public pure returns (uint256) {
        return 100e18;
    }

    function decimals() public pure returns (uint256) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        if (s_balances[msg.sender] < _amount) {
            revert ManualToken__NotEnoughBalanceError(
                msg.sender,
                s_balances[msg.sender],
                _amount
            );
        }

        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }
}
