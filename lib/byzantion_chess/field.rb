module ByzantionChess

  class Field
    attr_reader :vertical_line, :horizontal_line
    
    def initialize(vertical_line, horizontal_line)
      raise WrongFieldException unless (0..7).include?(vertical_line) && (0..7).include?(horizontal_line)
      @vertical_line = vertical_line
      @horizontal_line = horizontal_line
    end
    
    def to_s
      (@vertical_line+97).chr + (@horizontal_line+1).to_s
    end
    
    def self.to_field(square)
      square.present? ? Field.new(square[0].ord-97, square[1].to_i-1) : nil
    end
    
    def self.get_fields_between(origin, destination)
      return WrongMoveException unless origin.kind_of?(Field) && destination.kind_of?(Field)
      fields = []
      if destination.accessible_by_vertical_line(origin)
        range_helper(destination.horizontal_line..origin.horizontal_line).each do |hor|
          fields << Field.new(origin.vertical_line, hor)
        end
      elsif destination.accessible_by_horizontal_line(origin)
        range_helper(destination.vertical_line..origin.vertical_line).each do |ver|
          fields << Field.new(ver, origin.horizontal_line)
        end
      elsif destination.accessible_by_diagonal(origin)
        (((destination.horizontal_line-origin.horizontal_line).abs)-1).times do |i|
          i = i+1
          if destination.vertical_line > origin.vertical_line &&
            destination.horizontal_line > origin.horizontal_line
            fields << Field.new(origin.vertical_line+i, origin.horizontal_line+i)
          elsif destination.vertical_line > origin.vertical_line &&
            destination.horizontal_line < origin.horizontal_line
            fields << Field.new(origin.vertical_line+i, origin.horizontal_line-i)
          elsif destination.vertical_line < origin.vertical_line &&
            destination.horizontal_line > origin.horizontal_line
            fields << Field.new(origin.vertical_line-i, origin.horizontal_line+i)
          else
            fields << Field.new(origin.vertical_line-i, origin.horizontal_line-i)
          end
        end
      end
      fields
    end
    
    def accessible_by_vertical_line(field, limit=8)
      @vertical_line == field.vertical_line && ((@horizontal_line-field.horizontal_line).abs <= limit)
    end
    
    def accessible_by_horizontal_line(field, limit=8)
      @horizontal_line == field.horizontal_line && ((@vertical_line-field.vertical_line).abs <= limit)
    end
    
    def accessible_by_line(field)
      vertical_line == field.vertical_line || @horizontal_line == field.horizontal_line
    end
    
    def accessible_by_diagonal(field, limit=8)
      (@vertical_line-field.vertical_line).abs == (@horizontal_line-field.horizontal_line).abs &&
      (@vertical_line-field.vertical_line).abs <= limit
    end
    
    def accessible_by_jump(field)
      (1..2).include?((@vertical_line-field.vertical_line).abs) &&
      (1..2).include?((@horizontal_line-field.horizontal_line).abs) &&
      (@vertical_line-field.vertical_line).abs + (@horizontal_line-field.horizontal_line).abs == 3
    end

    def neighbour_field(column, line)
      Field.new(self.vertical_line+column, self.horizontal_line+line)
    end
    
    private
    
    def self.range_helper range
      borders = [range.begin, range.end]
     (borders.min+1..borders.max-1)
    end
  end
end
