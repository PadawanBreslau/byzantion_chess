module ByzantionChess
  module ByzantionHelper

    def white?(piece)
      piece.color == ByzantionChess::WHITE
    end

    def black?(piece)
      piece.color == ByzantionChess::BLACK
    end

    def white_to_move?(board)
      board.to_move == ByzantionChess::WHITE
    end

    def black_to_move?(board)
      board.to_move == ByzantionChess::BLACK
    end

    def get_king(board, color)
      board.pieces.select{|piece| piece.kind_of?(ByzantionChess::King) && piece.color == color}.first
    end

    def next_color(color)
      ([ByzantionChess::WHITE, ByzantionChess::BLACK] - [color]).first
    end
  end
end
