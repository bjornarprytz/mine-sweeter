# mine-sweeter

game on itch.io: [link](https://thewarlock.itch.io/mine-sweeter)

This game is a submission to this jam: https://itch.io/jam/clone-jam-game-a-month

Stipulation: Cards

It's a clone of the game "Minesweeper" with a few twists:



## TODO

- Initialization
  - Add cards to the board
  - Tutorialize the open of a cell

- Gameplay loop
  - OnOpenCell
    - If the revealed cell is adjacent to a mine
      - Add 1 card to the deck
    - If the revealed cell is a mine, trip it
    - If any mines are isolated, score them

- Mines
  - Value mines (4, 5, or 6)

- Tripping a mine
  - Either
    - Mill X cards, where X is the mine value
    - Add X bad cards

- Scoring mines
  - Draw X cards, where X is the cumulative value of the scored mines
    - Add value cards
    - Multiply score by multiplier cards
    - Discard the scored cards

- Deck
  - Add Cards (to the bottom)
  - Draw Cards (from the top)
  - Mill Cards (from the top)
  - Shuffle Cards

- QoL
  - Auto-flag cells where it's obvious (sum unrevealed adjacent cells, if the sum is the value of the cell, then all unrevealed cells are mines)

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
