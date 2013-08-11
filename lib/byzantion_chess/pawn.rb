class ByzantionChess::Pawn < ByzantionChess::Piece

  def initialize field, color, board=nil
    raise InvalidPawnPositionException if field.horizontal_line == 1 || field.horizontal_line == 8
    super field, color, board
  end

  def can_move_to_field? destination
    @moved ? @field.accessible_by_vertical_line?(destination, 1) : @field.accessible_by_vertical_line?(destination, 2)
  end

  def can_take_on_field? destination
    direction = @color == ByzantionChess::WHITE ? 1 : -1
    @field.accessible_by_diagonal?(destination,1) &&
    @field.horizontal_line == destination.horizontal_line - direction
  end

  def how_many_fields
    (@color == WHITE && @field.horizontal_line == 2 || @color == BLACK && @field.horizontal_line == 7) ? 2 : 1
  end
end