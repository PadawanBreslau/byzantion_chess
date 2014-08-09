require 'byzantion_chess'

class PgnFileContent
  attr_accessor :content

  def initialize(content, logger=nil)
    @content = content
    @logger = logger
  end

  def parse_games
    @logger.info @content if @logger
    parsed_file = Parser.parse(@content)
    parsed_file.map do |one_game|
      game = Game.new(one_game)
      game.convert_body_to_moves
      game
    end
  end
end
