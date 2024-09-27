# PokeDIO - NFT Pokémon Game

Este projeto foi criado como parte do **Bootcamp DIO Binance**. O objetivo é desenvolver um jogo utilizando NFTs baseados em Pokémon, onde os jogadores podem colecionar, batalhar e evoluir seus Pokémons em um ambiente descentralizado na blockchain.

## Descrição do Projeto

O **PokeDIO** é um jogo onde cada Pokémon é representado como um token ERC-721, permitindo que os jogadores colecionem, troquem e batalhem com seus Pokémons no blockchain. O jogo utiliza contratos inteligentes no Solidity para gerenciar a criação de Pokémons e as batalhas entre eles.

### Funcionalidades

- **Criação de Pokémon**: O game owner pode criar novos Pokémons, definindo nome e imagem.
- **Batalhas entre Pokémons**: Os Pokémons podem batalhar entre si. O nível do Pokémon vencedor aumenta de acordo com o resultado da batalha.
- **Sistema de Propriedade**: Apenas o dono de um Pokémon pode utilizá-lo nas batalhas.

## Código

O código do contrato inteligente foi implementado em Solidity e utiliza a biblioteca OpenZeppelin para o padrão ERC-721.

```solidity
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
