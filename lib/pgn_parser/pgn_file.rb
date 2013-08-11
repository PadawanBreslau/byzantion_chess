require 'byzantion_chess.rb'


class PgnFile
  attr_accessor :filepath, :games
 
  def initialize(filepath)
  	raise ByzantionChess::InvalidPGNFile.new("Not a pgn extension") unless filepath[-3..-1] == 'pgn'
    @filepath = filepath
    @games = []
  end

  def load_and_parse_games
    raise ByzantionChess::InvalidPGNFile.new("PgnFileNotFound") unless File.exists?(filepath)
    file = File.open(filepath, "rb")
    content = file.read
    raise ByzantionChess::InvalidPGNFile.new("PgnFileEmpty") if content.blank?

    begin
      self.games = parse_games(content)
    rescue ByzantionChess::InvalidPGNFile => e
      puts e.backtrace
      return false
    ensure	
      file.close
    end

    return true
  end	

private

  def parse_games(content)
  	parsed_file = Parser.parse(content)
    parsed_file.map do |one_game|
      game = Game.new(one_game)
      game.convert_body_to_moves
      game
    end  
  end
end