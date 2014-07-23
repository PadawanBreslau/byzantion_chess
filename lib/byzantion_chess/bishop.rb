class ByzantionChess::Bishop < ByzantionChess::Piece

  def to_s(locale = :en)
    piece = case locale
      when :en then 'B'
      when :pl then 'G'
    end
    piece
  end

  def can_move_to_field? destination
    @field.accessible_by_diagonal?(destination)
  end
end
