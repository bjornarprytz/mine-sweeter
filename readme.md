# mine-sweeter

game on itch.io: [link](https://thewarlock.itch.io/mine-sweeter)

This game is a submission to this jam: https://itch.io/jam/clone-jam-game-a-month

Stipulation: Cards

It's a clone of the game "Minesweeper" with a few twists:

## TODO

- Juice
  - Tweak sound effects much more
  - Sound effects (adjust with random pitch)
    - Scoring
      - Reveal cards
      - Add points
    - Deck
      - Add card
      - Remove cards (Mine)
    - Cell
      - Reveal (Good/Mine)
      - Flag/Unflag
      - Add exp
  - Destroy cards
    - Particles

- Initialization
  - Tutorialize the open of a cell

- QoL
  - Check mark cells that are completely flagged/mined
  - Grey out cells that are safe, and mines that are flagged and confirmed
  - Option: Auto-flag cells where it's obvious (sum unrevealed adjacent cells, if the sum is the value of the cell, then all unrevealed cells are mines)

- Attribution:
  - Sound Effects from <a href="https://pixabay.com/sound-effects/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=43207">Pixabay</a>
  - Sound Effect by <a href="https://pixabay.com/users/driken5482-45721595/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=236671">Driken Stan</a> from <a href="https://pixabay.com/sound-effects//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=236671">Pixabay</a>

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
