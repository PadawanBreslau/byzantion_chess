class ByzantionChess::Rook < ByzantionChess::Piece

  def to_s(locale = :en)
    piece = case locale
      when :en then 'R'
      when :pl then 'W'
    end
    piece
  end

  def can_move_to_field? destination
    @field.accessible_by_line?(destination)
  end
end
