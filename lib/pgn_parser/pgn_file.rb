require 'byzantion_chess'


class PgnFile
  attr_accessor :filepath, :games

  def initialize(filepath)
  	raise ByzantionChess::InvalidPGNFile.new("Not a pgn extension") unless filepath[-3..-1] == 'pgn'  # TODO Fole.extname
    @filepath = filepath
    @games = []
  end

  def load_and_parse_games
    raise ByzantionChess::InvalidPGNFile.new("PgnFileNotFound") unless File.exists?(filepath)
    file = File.open(filepath, "rb")
    content = file.read
    raise ByzantionChess::InvalidPGNFile.new("PgnFileEmpty") if content.blank?

    begin
      pgn_content = PgnFileContent.new(content)
      self.games = pgn_content.parse_games
    rescue ByzantionChess::InvalidPGNFile => e
      puts e.backtrace
      return false
    ensure
      file.close
    end

    return true
  end

end
