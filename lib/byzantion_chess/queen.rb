class ByzantionChess::Queen < ByzantionChess::Piece

  def to_s(locale = :en)
    piece = case locale
      when :en then 'Q'
      when :pl then 'H'
    end
    piece
  end

  def can_move_to_field?(destination)
    @field.accessible_by_line?(destination) || @field.accessible_by_diagonal?(destination)
  end
end
