class ByzantionChess::Queen < ByzantionChess::Piece
  def can_move_to_field? field
   #((@column == field[0]) ^ (@line == field[1])) || self.same_diagonal?(field)
  end
end