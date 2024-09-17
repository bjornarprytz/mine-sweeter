# mine-sweeter

game on itch.io: [link](https://thewarlock.itch.io/mine-sweeter)

This game is a submission to this jam: https://itch.io/jam/clone-jam-game-a-month

Stipulation: Cards

It's a clone of the game "Minesweeper" with a few twists:



## TODO

- Initialization
  - Tutorialize the open of a cell

- Mines
  - Value mines (4, 5, or 6)
    - Update hard-coded mine values in main.gd

- Tripping a mine
  - Either
    - Mill X cards, where X is the mine value
    - Add X bad cards

- Scoring mines
  - Discard the scored cards?
  - Make the mine unable to be scored again

- QoL
  - Check mark cells that are completely flagged/mined
  - Grey out cells that are safe, and mines that are flagged and confirmed
  - Option: Auto-flag cells where it's obvious (sum unrevealed adjacent cells, if the sum is the value of the cell, then all unrevealed cells are mines)

- Push release with `./push_release.sh`

### Extra

- itch.io
  - Rename the game
  - Write a short description
  - Make a nice cover image (630x500)
  - Add screenshots (recommended: 3-5)
  - Pick a genre
  - Add a tag or two
  - Publish a devlog on instagram

### Meta

- Figure out how to use these Godot tools
  - Theme
  - UI
- Tackle multiplayer in HTML5
  - https://www.reddit.com/r/godot/comments/bux2hs/how_to_use_godots_high_level_multiplayer_api_with/
