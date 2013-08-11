class ByzantionChess::Rook < ByzantionChess::Piece
  def can_move_to_field? destination
    @field.accessible_by_line?(destination)
  end
end