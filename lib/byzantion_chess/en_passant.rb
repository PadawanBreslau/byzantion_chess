module ByzantionChess
  class EnPassant < Move
    attr_reader :board, :move

    def initialize(start_field, finish_field, color = nil, number = nil)
      super(start_field, finish_field, color, number)
      raise InvalidMoveException.new("Not a valid en passant") unless en_passant_allowed?
    end

    def execute(board)
      board.execute_en_passant(self)
    end

    private

    def en_passant_allowed?
      Field.to_field(@start).accessible_by_diagonal?(Field.to_field(@finish),1)
    end

  end
end
