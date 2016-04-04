module ByzantionChess
  class Castle < Move
    START_FIELDS = %w(e1 e8)
    FINISH_FIELDS = %w(g1 g8 c1 c8)

    attr_accessor :board

    def initialize(start_field, finish_field, color = nil, number = nil)
      super(start_field, finish_field, color, number)

      unless valid_start_or_finish?(start_field, finish_field)
        raise InvalidMoveException.new('Castle move with wrong start or finish field')
      end
    end

    def execute(board)
      board.execute_castle(self)
    end

  private

    def valid_start_or_finish?(start_field, finish_field)
      START_FIELDS.include?(start_field.to_s) && FINISH_FIELDS.include?(finish_field.to_s) && (start_field[-1] == finish_field[-1])
    end

    def castle
      raise ImpossibleCastleException unless castle_possible?(@move)
      rook = select_rook(@move)
      castle_horizontal_line = select_horizontal_line
      castle_vertical_line =  @piece.vertical_line - @move.finish.vertical_line < 0 ? "f" : "d"
      rook.update_position(Field.to_field("#{castle_vertical_line}#{castle_horizontal_line}"))
      rook.moved = true
      @piece.update_position(@move.finish)
      @piece.moved = true
      @board.to_move = @board.update_to_move
    end

    def select_rook(move)
      rook_vertical_line = @piece.vertical_line-move.finish.vertical_line < 0 ? "h" : "a"
      rook_horizontal_line = select_horizontal_line
      @board.piece_from("#{rook_vertical_line}#{rook_horizontal_line}")
    end

    def select_horizontal_line
      @board.to_move == ByzantionChess::WHITE ? "1" : "8"
    end

    def rook_moved?(move)
      select_rook(move).moved?
    end

    def path_checked?(move)
      pieces = @board.pieces.select{|piece| piece.color != @board.to_move}
      king = @board.select_piece(ByzantionChess::King, @board.to_move).first
      horizontal_line = select_horizontal_line
      vertical_line = @piece.vertical_line-move.finish.vertical_line < 0 ? "h" : "a"

      fields = Field.get_fields_between(king.field, Field.to_field("#{vertical_line}#{horizontal_line}"))
      fields.each do |field|
        pieces.each do |piece|
          return true if piece.can_take_on_field?(field) && board.path_is_not_obstructed?(piece,field)
        end
      end
      false
    end

    def castle_possible?(move)
      @board.path_is_not_obstructed?(@piece, move.finish) && !@piece.moved &&
      !rook_moved?(move) && !@board.king_checked? && !path_checked?(move)
    end
  end
end
