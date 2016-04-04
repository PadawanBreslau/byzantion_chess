module ByzantionChess
  class BoardHelper

    def initialize(board)
      @board = board
    end

    def valid_position?
      return false if select_piece(King, WHITE).size != 1 &&
          select_piece(King, BLACK) != 1
      @board.pieces.each_pair{|a,b| return false if a.same_location_as?(b)}
    end

    def select_piece(klass,color)
      @board.pieces.select{|piece| piece.class == klass && piece.get_color == color}
    end

    def piece_from(field_string)
      field_taken(Field.to_field(field_string))
    end

    def field_taken(field)
      @board.pieces.each do |p|
        return p if p.horizontal_line == field.horizontal_line && p.vertical_line == field.vertical_line
      end
      false
    end

    def king_checked?
      pieces = @board.pieces.select{|piece| piece.color != @board.to_move}
      king = select_piece(King, @board.to_move).first
      pieces.each do |piece|
        return true if piece.can_take_on_field?(king.field) && self.path_is_not_obstructed?(piece, king.field)
      end
      false
    end

    def add_piece(piece)
      return false unless piece
      field_taken(piece.field).present? ? (raise BoardSetupException.new("Duplicate pieces for a field")) : (@board.pieces << piece)

    end

    def get_possible_pieces(piece_type, color, field, additional_info = nil)
      pieces = @board.pieces.
        select{|piece| piece.kind_of?(piece_type) && piece.color == color}.
        select{|piece| self.path_is_not_obstructed?(piece, field) && (piece.can_move_to_field?(field) || piece_can_take_on_field?(piece, field) || piece.can_en_passant?(@board, color, field) ) && self.piece_is_not_bound?(piece, color, field)}

      (pieces.size > 1 && additional_info) ? select_piece_by_additional_info(pieces, additional_info) : pieces
    end

    def piece_can_take_on_field?(piece, field)
      piece.can_take_on_field?(field) && field_taken(field)
    end

    def get_possible_pieces_from_move(move)
      piece = piece_from(move.start)
      get_possible_pieces(piece.class, piece.color, move.finish, move.additional_info)
    end

    def path_is_not_obstructed?(piece, destination)
      return true if piece.class == ByzantionChess::Knight
      fields = Field.get_fields_between(piece.field, destination)

      fields.each do |field|
        return false if field_taken(field)
      end
      true
    end

    def piece_is_not_bound?(original_piece, color, destination)
      ByzantionChess::ChessValidations::PieceBoundCheck.new(@board, original_piece, color, destination).check
    end

    def validate_move(move, piece ,destination)
      piece_on_destination = piece_from(destination)
      raise InvalidMoveException.new("Impossible move: #{move} for piece: #{piece}") if !piece.can_move_to_field?(destination) && !piece.can_take_on_field?(destination)
      raise InvalidMoveException.new("Cannot make move: #{move} with #{piece} - path obstructed") unless path_is_not_obstructed?(piece, destination)
      raise InvalidMoveException.new("Trying to take an own piece: #{move}") if piece_on_destination && piece.color == piece_on_destination.color
      true
    end

    def destroy_piece_on_field field
      pieces_count = @board.pieces.count
      @board.pieces.delete_if{|piece| piece.vertical_line == field.vertical_line && piece.horizontal_line == field.horizontal_line}
      return pieces_count != @board.pieces.count
    end

    private

    def select_piece_by_additional_info(pieces, additional_info)
      pieces.select{|piece| piece.field.to_s.include?(additional_info)}
    end

  end
end
