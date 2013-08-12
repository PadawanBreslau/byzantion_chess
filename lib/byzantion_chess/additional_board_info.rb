class AdditionalBoardInfo

  attr_reader :white_castle_possible, :black_castle_possible, :en_passant, :is_check, :is_mate, :to_move
  attr_accessor :en_passant


  def initialize(move)
    @white_castle_possible = {:long => true, :short => true}
    @black_castle_possible = {:long => true, :short => true}
    @en_passant = false
    @is_check = false
    @is_mate = false
    @to_move = move
  end


end