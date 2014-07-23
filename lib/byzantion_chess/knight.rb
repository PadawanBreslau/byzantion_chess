class ByzantionChess::Knight < ByzantionChess::Piece

  def to_s(locale = :en)
    piece = case locale
      when :en then 'N'
      when :pl then 'S'
    end
    piece
  end

  def can_move_to_field? destination
    @field.accessible_by_jump?(destination)
  end
end
