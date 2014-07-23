class ByzantionChess::King < ByzantionChess::Piece

  def to_s(locale = :en)
    piece = case locale
      when :en then 'K'
      when :pl then 'K'
    end
    piece
  end

  def can_move_to_field?(destination)
    @field.accessible_by_vertical_line?(destination,1) || @field.accessible_by_horizontal_line?(destination,1) || @field.accessible_by_diagonal?(destination,1) || castle_possible?(destination)
  end

  private

  def castle_possible?(destination)
    !self.moved? && @field.accessible_by_horizontal_line?(destination,2)
  end
end
