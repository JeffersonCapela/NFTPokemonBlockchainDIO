// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CapelaMonsters is ERC721 {

    struct Monster {
        string name;
        uint level;
        string img;
    }

    Monster[] public monsters;
    address public owner;

    constructor() ERC721("CapelaMonsters", "CAP") {
        owner = msg.sender;
    }

    modifier onlyMonsterOwner(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender, "Somente o proprietario pode usar este monstro");
        _;
    }

    modifier onlyGameOwner() {
        require(msg.sender == owner, "Apenas o dono do jogo pode executar essa acao");
        _;
    }

    function battle(uint _attackerId, uint _defenderId) public onlyMonsterOwner(_attackerId) {
        Monster storage attacker = monsters[_attackerId];
        Monster storage defender = monsters[_defenderId];

        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewMonster(string memory _name, address _to, string memory _img) public onlyGameOwner {
        uint id = monsters.length;
        monsters.push(Monster(_name, 1, _img));
        _safeMint(_to, id);
    }
}
