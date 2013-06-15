class ByzantionChess::King < ByzantionChess::Piece
  def can_move_to_field? field
    #return false if field[0] == @column && field[1] == @line
    #(field[0].succ == @column || field[0] == @column.succ || field[0] == @column ) && (field[1].succ == @line || field[1] == @line.succ || field[1] == @line)
  end
end