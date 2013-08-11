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


=begin
    def get_pawns
      return [] if board.moves.empty? || !@board.moves.last.en_passant
      all_pawns = board.select_piece(ByzantionChess::Pawn, @board.to_move)
      last_move = @board.moves.last
      all_pawns.keep_if{|pawn| pawn.horizontal_line == last_move.finish.horizontal_line && (pawn.vertical_line-last_move.finish.vertical_line).abs == 1}
      puts all_pawns if all_pawns.present?
      all_pawns
    end
=end
  
  end
end