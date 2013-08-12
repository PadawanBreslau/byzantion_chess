module ByzantionChess
  class EnPassant < Move
  
    attr_reader :board, :move

    def initialize(start_field, finish_field, color = nil, number = nil)
      super(start_field, finish_field, color, number)
      raise InvalidMoveException.new("Not a valid en passant") unless Field.to_field(start_field).accessible_by_diagonal?(Field.to_field(finish_field),1)
    end


    def execute(board)
      board.execute_en_passant(self)
    end

  end
end