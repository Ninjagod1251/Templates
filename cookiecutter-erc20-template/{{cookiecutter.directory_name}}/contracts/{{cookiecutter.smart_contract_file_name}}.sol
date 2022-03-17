// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/access/Ownable.sol";
{%- if cookiecutter.burnable == 'y' %} 
import "@openzeppelin/token/ERC20/extensions/ERC20Burnable.sol"; {%- endif %}
{%- if cookiecutter.pausable == 'y' %} 
import "@openzeppelin/security/Pausable.sol";  {%- endif %}
{%- if cookiecutter.permit == 'y' %} 
import "@openzeppelin/token/ERC20/extensions/draft-ERC20Permit.sol"; {%- endif %}
{%- if cookiecutter.votes == 'y' %} 
import "@openzeppelin/token/ERC20/extensions/ERC20Votes.sol"; {%- endif %}
{%- if cookiecutter.flashminting == 'y' %} 
import "@openzeppelin/token/ERC20/extensions/ERC20FlashMint.sol"; {%- endif %}
{%- if cookiecutter.snapshot == 'y' %} 
import "@openzeppelin/token/ERC20/extensions/ERC20Snapshot.sol"; {%- endif %}


contract {{cookiecutter.smart_contract_file_name}} is ERC20 , Ownable 
{%- if cookiecutter.burnable == 'y' %}, ERC20Burnable {%- endif %}
{%- if cookiecutter.pausable == 'y' %}, Pausable {%- endif %}
{%- if cookiecutter.votes == 'y' %}, ERC20Votes  {%- endif %}
{%- if cookiecutter.flashminting == 'y' %}, ERC20FlashMint  {%- endif %}
{%- if cookiecutter.snapshot == 'y' %}, ERC20Snapshot  {%- endif %} {
    constructor() ERC20("{{cookiecutter.token_name}}", "{{cookiecutter.token_symbol}}") {%- if cookiecutter.permit == 'y' or (cookiecutter.votes == 'y') %} ERC20Permit("{{cookiecutter.token_name}}") {%- endif %}{
{%- if cookiecutter.premint == 'y' %} 
        _mint(msg.sender, {{cookiecutter.premint_amount}} * 10 ** decimals());
{%- endif %}
    }

{%- if cookiecutter.snapshot == 'y' %} 
function snapshot() public onlyOwner {
        _snapshot();
    }
{%- endif %}

{%- if cookiecutter.pausable == 'y' %} 
    
        function pause() public onlyOwner {
        _pause();
    }
    
        function unpause() public onlyOwner {
        _unpause();
    }

{%- endif %}

{%- if cookiecutter.mintable == 'y' %} 
        function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
{%- endif %}

{%- if (cookiecutter.pausable == 'y') or (cookiecutter.snapshot == 'y') %} 

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        {%if cookiecutter.pausable == 'y' %}whenNotPaused
        {%- endif %}
        {%if cookiecutter.snapshot == 'y' %}override(ERC20, ERC20Snapshot)
        {%- else %}
        override
        {%- endif %}
    {
        super._beforeTokenTransfer(from, to, amount);
    }

{%- endif %}

{%- if cookiecutter.votes == 'y' %} 

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

{%- endif %}
}
