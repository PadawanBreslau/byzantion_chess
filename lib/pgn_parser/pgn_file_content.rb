require 'byzantion_chess'

class PgnFileContent
  def initialize(content)
    @content = content
  end

  def parse_games(content)
  	parsed_file = Parser.parse(content)
    parsed_file.map do |one_game|
      game = Game.new(one_game)
      game.convert_body_to_moves
      game
    end
  end
end
