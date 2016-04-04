module ByzantionChess
  module ChessValidations
    class PieceBoundCheck
    include ByzantionHelper
      BINDABLE_PIECES = [ByzantionChess::Queen, ByzantionChess::Rook, ByzantionChess::Bishop]

      def initialize(board, original_piece, color, destination)
        @board = board
        @original_piece = original_piece
        @color = color
        @destination = destination
      end

      def check
        king = get_king(@board, @color)
        opponent_pieces = select_bindable_pieces(@color, king)
        field_between_piece_and_king = Field.get_fields_between(@original_piece.field, king.field).map(&:to_s)
        opponent_pieces.each do |opp_piece|
          fields_between = Field.get_fields_between(opp_piece.field, king.field).map(&:to_s)
          field_between_piece_and_opponent_piece = (fields_between - field_between_piece_and_king) - [ @original_piece.field.to_s ]
          return false if fields_between.include?(@original_piece.field.to_s) &&
            field_between_piece_and_king.select{|field| @board.piece_from(field) }.empty? &&
            field_between_piece_and_opponent_piece.select{|field| @board.piece_from(field) }.empty? &&
            !fields_between.include?(@destination.to_s) &&
            opp_piece.field.to_s != @destination.to_s
        end
        true
      end

      private

      def select_bindable_pieces(color, king)
        @board.pieces.select{|piece| piece.color != @color && BINDABLE_PIECES.include?(piece.class) && piece.can_move_to_field?(king.field)}
      end
    end
  end
end
