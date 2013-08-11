class AdditionalMoveInfo

  attr_reader :number, :promotion_to, :color

  def initialize(color, number)
    raise ByzantionChess::InvalidMoveException.new("Invalid color: #{color}") unless [ByzantionChess::WHITE, ByzantionChess::BLACK].include? color
    @color = color
    @number = number
    #@promotion_to = promotion_to
  end

end