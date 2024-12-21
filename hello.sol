// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleArcadeEducationalGames {
    address public owner;

    struct Game {
        string title;
        string description;
        uint256 playFee;
        uint256 reward;
    }

    Game[] public games;
    mapping(address => uint256) public playerScores;

    event GameAdded(string title, uint256 playFee, uint256 reward);
    event GamePlayed(address player, string title, uint256 score);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addGame(
        string memory _title,
        string memory _description,
        uint256 _playFee,
        uint256 _reward
    ) public onlyOwner {
        games.push(Game(_title, _description, _playFee, _reward));
        emit GameAdded(_title, _playFee, _reward);
    }

    function playGame(uint256 gameIndex, uint256 score) public payable {
        require(gameIndex < games.length, "Game does not exist.");
        Game memory game = games[gameIndex];
        require(msg.value >= game.playFee, "Insufficient play fee.");

        if (score >= 80) {
            playerScores[msg.sender] += score;
            payable(msg.sender).transfer(game.reward);
        }

        emit GamePlayed(msg.sender, game.title, score);
    }

    function getGames() public view returns (Game[] memory) {
        return games;
    }

    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}