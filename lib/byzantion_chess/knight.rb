class ByzantionChess::Knight < ByzantionChess::Piece
  def can_move_to_field? destination
    @field.accessible_by_jump(destination)
  end
end