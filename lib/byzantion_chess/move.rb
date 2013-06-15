module ByzantionChess
  class Move
    attr_reader  :finish, :piece, :color, :number, :additional_info, :promotion_to
    attr_accessor :en_passant
    
    def initialize(piece, finish_field, number=nil, additional_info = nil)
      raise InvalidMoveException unless piece.kind_of? ByzantionChess::Piece
      @piece = piece
      @finish = Field.to_field(finish_field)
      @number = number
      @additional_info = additional_info
      @en_passant = false
      @promotion_to = nil
    end

    def set_promoted_to piece
      @promotion_to = piece
    end
       
  end 
end