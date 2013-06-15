module ByzantionChess
  class EnPassant
  
    attr_reader :board, :move
  
    def initialize(board,move)
      @board = board
      @move = move
    end

    def get_pawns
      all_pawns = board.select_piece(ByzantionChess::Pawn, @board.to_move)
      last_move = @board.moves.last
      all_pawns.keep_if{|pawn| pawn.horizontal_line == last_move.finish.horizontal_line && (pawn.vertical_line-last_move.finish.horizontal_line).abs == 1}
      all_pawns 
    end
  
  end
end