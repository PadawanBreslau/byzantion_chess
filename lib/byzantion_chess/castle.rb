module ByzantionChess
  class Castle < Move

  attr_accessor :board

    def initialize(start_field, finish_field, color = nil, number = nil)
      super(start_field, finish_field, color, number)
      start_fields = %w(e1 e8)
      finish_fields = %w(g1 g8 c1 c8)

      unless start_fields.include?(start_field.to_s) && finish_fields.include?(finish_field.to_s) && (start_field[-1] == finish_field[-1])
        raise InvalidMoveException.new('Castle move with wrong start or finish field')
      end

    end

    def execute(board)
      board.execute_castle(self)
    end




    def castle
      debugger unless castle_possible?(@move)
      raise ImpossibleCastleException unless castle_possible?(@move)
      rook = select_rook(@move)

      if @piece.vertical_line-@move.finish.vertical_line < 0
        if @board.to_move == ByzantionChess::WHITE
          rook.update_position(Field.to_field("f1"))
        else
          rook.update_position(Field.to_field("f8"))
        end
      else
        if @board.to_move == ByzantionChess::WHITE
          rook.update_position(Field.to_field("d1"))
        else
          rook.update_position(Field.to_field("d8"))
        end
      end

      rook.moved = true
      @piece.update_position(@move.finish)
      @piece.moved = true
      @board.to_move = @board.update_to_move

    end

    def select_rook(move)
      if @piece.vertical_line-move.finish.vertical_line < 0
        if @board.to_move == ByzantionChess::WHITE
          rook = @board.piece_from("h1")
        else
          rook = @board.piece_from("h8")
        end
      else
        if @board.to_move == ByzantionChess::WHITE
          rook = @board.piece_from("a1")
        else
          rook = @board.piece_from("a8")
        end
      end
      rook
    end

    def rook_moved?(move)
      select_rook(move).moved?
    end

    def path_checked?(move)
      pieces = @board.pieces.select{|piece| piece.color != @board.to_move}
      king = @board.select_piece(ByzantionChess::King, @board.to_move).first

      if @piece.vertical_line-move.finish.vertical_line < 0
        if @board.to_move == ByzantionChess::WHITE
          fields = Field.get_fields_between(king.field, Field.to_field("h1"))
        else
          fields = Field.get_fields_between(king.field, Field.to_field("h8"))
        end
      else
        if @board.to_move == ByzantionChess::WHITE
          fields = Field.get_fields_between(king.field, Field.to_field("a1"))
          fields.keep_if{|field| field.to_s != "b1"}
        else
          fields = Field.get_fields_between(king.field, Field.to_field("a8"))
          fields.keep_if{|field| field.to_s != "b8"}
        end
      end
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
