// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/token/ERC721/ERC721.sol";
{%- if cookiecutter.enumerable == 'y' %} 
import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
{%- endif %}
{%- if cookiecutter.uri_storage == 'y' %} 
import "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
{%- endif %}
{%- if cookiecutter.pausable == 'y' %} 
import "@openzeppelin/security/Pausable.sol"; {%- endif %}
{%- if cookiecutter.burnable == 'y' %} 
import "@openzeppelin/token/ERC721/extensions/ERC721Burnable.sol"; {%- endif %}
{%- if cookiecutter.uri_storage == 'y' %} 
import "@openzeppelin/access/Ownable.sol";
{% else %}
import "@openzeppelin/access/AccessControl.sol";{%- endif %}
{%- if cookiecutter.countable == 'y' %} 
import "@openzeppelin/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/token/ERC721/extensions/draft-ERC721Votes.sol"; {%- endif %}
{%- if cookiecutter.countable == 'y' %} 
import "@openzeppelin/utils/Counters.sol"; {%- endif %}

contract {{cookiecutter.smart_contract_file_name}} is ERC721
{%- if cookiecutter.burnable == 'y' %}, ERC721Burnable {%- endif %} 
{%- if cookiecutter.ownable == 'y' %}, Ownable 
{% else %}
, AccessControl
{%- endif %}  
{%- if cookiecutter.pausable == 'y' %}, Pausable {%- endif %}
{%- if cookiecutter.burnable == 'y' %}, ERC721Burnable {%- endif %}
{
{%- if cookiecutter.countable == 'y' %} 
    using Counters for Counters.Counter; 
{%- if cookiecutter.ownable == 'n'%}
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
{%- endif %}
    Counters.Counter private _tokenIdCounter;
{%- endif %}

    constructor() ERC721("{{cookiecutter.token_name}}", "{{cookiecutter.token_symbol}}") {
{%- if cookiecutter.ownable == 'n'%}
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _grantRole(PAUSER_ROLE, msg.sender);
    _grantRole(MINTER_ROLE, msg.sender);
{%- endif %}
    }

{%- if cookiecutter.baseuri == 'y' %} 
    function _baseURI() internal pure override returns (string memory) {
            return "{{cookiecutter.baseuri_string}}";
        }
{%- endif %}

{%- if cookiecutter.pausable == 'y' %} 
    function pause() public {%- if cookiecutter.ownable == 'n'%} onlyOwner  {% else %} onlyRole(PAUSER_ROLE) {%- endif %}{
        _pause();
    }

    function unpause() public {%- if cookiecutter.ownable == 'n'%} onlyOwner  {% else %} onlyRole(PAUSER_ROLE) {%- endif %} {
        _unpause();
    }
{%- endif %}
    
{%- if cookiecutter.mintable == 'y' %} 
    function safeMint(address to) public {%- if cookiecutter.ownable == 'n'%} onlyOwner  {% else %} onlyRole(MINTER_ROLE) {%- endif %} {
            {%-if cookiecutter.countable == 'y' %} 
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            {%- endif %}
            _safeMint(to, tokenId);
        }
{%- endif %}

{%- if (cookiecutter.pausable == 'y') or (cookiecutter.enumerable == 'y') %}

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        {%if cookiecutter.pausable == 'y' %}whenNotPaused
        {%- endif %}
        {%if cookiecutter.enumerable == 'y' %}override(ERC721, ERC721Enumerable)
        {%- else %}
        override
        {%- endif %}   
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
{%- endif %}

{%- if cookiecutter.votes == 'y' %} 
    function _afterTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId);
    }
{%- endif %}

{%- if cookiecutter.uri_storage == 'y' %}
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
{%- endif %}

{%- if (cookiecutter.ownable == 'n')  or (cookiecutter.enumerable == 'y') %}
    function supportsInterface(bytes4 interfaceId)
            public
            view
            override(ERC721 
            {%- if cookiecutter.ownable == 'n'%}, AccessControl {%- endif %} 
            {%- if cookiecutter.enumerable == 'y'%}, ERC721Enumerable {%- endif %} )
            returns (bool)
        {
            return super.supportsInterface(interfaceId);
        }
{%- endif %}
}