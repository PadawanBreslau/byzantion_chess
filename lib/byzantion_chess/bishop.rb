class ByzantionChess::Bishop < ByzantionChess::Piece
  def can_move_to_field? destination
    @field.accessible_by_diagonal?(destination)
  end
end