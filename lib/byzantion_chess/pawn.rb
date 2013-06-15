class ByzantionChess::Pawn < ByzantionChess::Piece

  def initialize field, color
    raise InvalidPawnPositionException if field.horizontal_line == 0 || field.horizontal_line == 7
    super field, color
  end

  def can_move_to_field? destination
    @moved ? @field.accessible_by_vertical_line(destination, 1) : @field.accessible_by_vertical_line(destination, 2) 
  end

  def can_take_on_field? destination
    direction = @color == ByzantionChess::WHITE ? 1 : -1
    @field.accessible_by_diagonal(destination,1) &&
    @field.horizontal_line == destination.horizontal_line - direction
  end

  def how_many_fields
    (@color == WHITE && @field.horizontal_line == 1 || @color == BLACK && @field.horizontal_line == 6) ? 2 : 1
  end
end