class AdditionalMoveInfo

  attr_reader :number, :promotion_to, :color
  attr_accessor :comment

  def initialize(color, number, comment=nil)
    raise ByzantionChess::InvalidMoveException.new("Invalid color: #{color}") unless [ByzantionChess::WHITE, ByzantionChess::BLACK].include? color
    @color = color
    @number = number
    @comment = comment
  end

end