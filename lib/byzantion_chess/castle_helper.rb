module ByzantionChess
  class CastleHelper
    def initialize(board)
      @board = board
    end


    def castle_possible?(piece, type)
      piece.color == ByzantionChess::WHITE ? @board.additional_info.white_castle_possible[type] : @board.additional_info.black_castle_possible[type]
    end

    def update_rook_position(color, type)
      vertical_line = (type == :long) ? "a" : "h"
      destination_vertical_line = (type == :long) ? "c" : "f"
      horizontal_line = color == ByzantionChess::WHITE ? "1" : "8"
      piece = @board.piece_from(Field.to_field(vertical_line.concat(horizontal_line)))
      piece.update_position(Field.to_field(destination_vertical_line.concat(horizontal_line)))
    end

  end
end