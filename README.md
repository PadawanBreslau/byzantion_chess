# ByzantionChess

## Description
Gem for reading and writing chess games from PGN format, emulate and validate game on virtual chessboard

```ruby
ByzantionChess.new
```

## Anti-Features
- Does not add computer analysis
- Does not support any game visualisation
- Variation support is to be improved and may not be working

## Installation

`$ gem install byzantion_chess` or add to your Gemfile this line: `gem 'byzantion_chess'` then run `bundle install`

## Usage

Just `require 'byzantion_chess'` and then use it as:

### Parse PGN file with games
```ruby
  PgnFileContent.new(FILENAME, LOGGER).parse_games
```
This will return an array of ByzantionChess::Game objects
Each object of ByzantionChess::Game class responds to two methods: header and moves
```ruby
  game.header =>
{"Event"=>"",
 "Site"=>"Deizisau (Germany)",
 "Date"=>"2005.03.28",
 "Round"=>"?",
 "White"=>"Bitalzadeh Ali (NED)",
 "Black"=>"Zawadzka Jolanta (POL)",
 "Result"=>"1-0",
 "ECO"=>"B80",
 "WhiteElo"=>"0",
 "BlackElo"=>"2259",
 "Annotator"=>"",
 "Source"=>"",
 "Remark"=>""}
```

Moves method returns hash - consists of each move on a proper level. "0" means the main game, "1" means game variations, "2" means variation variation and so on - as deep as the PGN variation is nested

```ruby
  game.moves["0"].map{|m| m.to_s} =>
["e2-e4", "c7-c5",
 "g1-f3", "d7-d6",
 "d2-d4", "c5-d4",
 "f3-d4", "g8-f6",
 "b1-c3", "a7-a6",
 "f2-f3", "e7-e5",
 "d4-b3", "c8-e6",
 "c1-e3", "b8-d7",
 "g2-g4", "b7-b5",
 "g4-g5", "b5-b4",
 "c3-d5", "f6-d5",
 "e4-d5", "e6-f5",
 "f1-d3", "f5-d3",
 "d1-d3", "f8-e7",
 "h2-h4", "e8-g8",
 "e1-g1", "a6-a5",
 "b3-d2", "f7-f5",
 "g5-f6", "e7-f6"]

game.moves["0"].first
=> #<ByzantionChess::Move:0x00000002e0b2b0
 @additional_info=#<AdditionalMoveInfo:0x00000002e0b260 @color="white", @comment=nil, @number="1">,
 @finish=#<ByzantionChess::Field:0x00000002e00b30 @horizontal_line=4, @vertical_line=5>,
 @start=#<ByzantionChess::Field:0x00000002dd5520 @horizontal_line=2, @vertical_line=5>,
 @variation_info=#<ByzantionChess::VariationInfo:0x00000002e0b210 @level=0, @move=#<ByzantionChess::Move:0x00000002e0b2b0 ...>, @previous_move=nil>>
```


## Contributing

1. Fork it.
2. Make your feature addition or bug fix and create your feature branch.
3. Update the Change Log if there is one
3. Add specs/tests for it. This is important so I don't break it in a future version unintentionally.
4. Commit, create a new Pull Request.
5. Check that your pull request passes the test

