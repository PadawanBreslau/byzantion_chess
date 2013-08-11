module ByzantionChess
  class Promotion < Move

    attr_reader :new_piece

    def initialize(new_piece, start_field, finish_field, color=nil, number=nil)
      @new_piece = new_piece
      super(start_field, finish_field,color,number)
    end

    def execute(board)
      board.execute_promotion(self)
    end

  end
end