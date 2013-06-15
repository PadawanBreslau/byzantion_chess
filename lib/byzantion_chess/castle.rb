module ByzantionChess
  class Castle

  attr_accessor :board

    def initialize(board, move)
      @board = board
      @move = move
    end
    
    def castle
      raise ImpossibleCastleException unless castle_posible?(@move)
      rook = select_rook(@move)
 
      if @move.piece.vertical_line-@move.finish.vertical_line < 0
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
      @move.piece.update_position(@move.finish)
      @move.piece.moved = true
      @board.to_move = @board.update_to_move
    end

    def select_rook(move)
      if move.piece.vertical_line-move.finish.vertical_line < 0
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
    end

    def rook_moved?(move)
      select_rook(move).moved?
    end

    def path_checked?(move)
      pieces = @board.pieces.select{|piece| piece.color != @board.to_move}
      king = @board.select_piece(ByzantionChess::King, @board.to_move).first
      
      if move.piece.vertical_line-move.finish.vertical_line < 0
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

    def castle_posible?(move)
      @board.path_is_not_obstructed?(move.piece, move.finish) && !move.piece.moved &&
      !rook_moved?(move) && !@board.king_checked? && !path_checked?(move)
    end

  end
end
