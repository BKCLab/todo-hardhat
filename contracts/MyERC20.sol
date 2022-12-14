// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

pragma solidity >=0.7.0 <0.9.0;

contract MyERC20 is IERC20, IERC20Metadata {
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initSupply_
    ) {
        _name = name_;
        _symbol = symbol_;
        _mint(msg.sender, initSupply_);
    }

    function name() external view virtual override returns (string memory) {
        return _name;
    }

    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() external view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function allowance(address owner, address spender)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(spender != address(0), "Not allow approve to zero address!");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function approve(address spender, uint256 amount)
        external
        virtual
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount)
        external
        virtual
        override
        returns (bool)
    {
        require(to != address(0), "Not allow transfer to zero address!");
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external virtual override returns (bool) {
        require(from != address(0), "from must not be zero address!");
        require(to != address(0), "to must not be zero address!");
        require(
            _allowances[from][msg.sender] >= amount,
            "Allowance is not enough"
        );
        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(_balances[from] >= amount, "Balance is not enough!");
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "to must not be zero address!");
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }
}
