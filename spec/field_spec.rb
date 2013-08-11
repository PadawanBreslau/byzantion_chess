require 'spec_helper'

describe ByzantionChess::Field do
  
  it 'should not create a field and raise error' do
    expect{ ByzantionChess::Field.new('a',1)}.to raise_exception
    expect{ ByzantionChess::Field.new(10,1)}.to raise_exception
    expect{ ByzantionChess::Field.new(-1,1)}.to raise_exception
    expect{ ByzantionChess::Field.new(9,9)}.to raise_exception
    expect{ ByzantionChess::Field.new([],1)}.to raise_exception
  end
  
  it 'should create a field' do
    field = ByzantionChess::Field.new(1,1)
    field.vertical_line.should eql 1
    field.horizontal_line.should eql 1
  end

  it 'should properly display field as chess string' do
    field = ByzantionChess::Field.new(1,1)
    field.vertical_line.should eql 1
    field.horizontal_line.should eql 1
    field.to_s.should eql "a1"

    field = ByzantionChess::Field.new(8,8)
    field.vertical_line.should eql 8
    field.horizontal_line.should eql 8
    field.to_s.should eql "h8"
  end
  
  
  it 'should be accessible by vertical line without limit' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(1,1)
    field1.accessible_by_line?(field2).should be_false
    (2..8).each do |i|
      field2 = ByzantionChess::Field.new(1,i)
      field1.accessible_by_vertical_line?(field2).should be_true
      field1.accessible_by_line?(field2).should be_true
    end
  end
    
  it 'should be accessible by horizontal line without limit' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(1,1)
    field1.accessible_by_line?(field2).should be_false
    (2..8).each do |i|
      field2 = ByzantionChess::Field.new(i,1)
      field1.accessible_by_horizontal_line?(field2).should be_true
      field1.accessible_by_line?(field2).should be_true
    end
  end
  
  it 'should not be accessible by vertical or horizontal line' do
    field1 = ByzantionChess::Field.new(1,1)
    (2..8).each do |i|
      (2..8).each do |j|
        field2 = ByzantionChess::Field.new(i,j)
        field1.accessible_by_line?(field2).should be_false
        field2.accessible_by_line?(field1).should be_false
      end
    end 
  end 
  
  it 'should be accessible by diagonal line without limit - 1' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(1,1)
    field1.accessible_by_diagonal?(field2).should be_false
    (2..8).each do |i|
      field2 = ByzantionChess::Field.new(i,i)
      field1.accessible_by_diagonal?(field2).should be_true
      field2.accessible_by_diagonal?(field1).should be_true
    end
  end
  
  it 'should be accessible by diagonal line without limit - 2' do
    field1 = ByzantionChess::Field.new(1,8)
    field2 = ByzantionChess::Field.new(1,8)
    field1.accessible_by_diagonal?(field2).should be_false
    (1..7).each do |i|
      field2 = ByzantionChess::Field.new(1+i,8-i)
      field1.accessible_by_diagonal?(field2).should be_true
      field2.accessible_by_diagonal?(field1).should be_true
    end
  end
  
  it 'should not be accessible by diagonal line' do
    field1 = ByzantionChess::Field.new(1,8)
    (1..8).each do |i|
      (1..8).each do |j|
        next if i+j = 9
        field2 = ByzantionChess::Field.new(i,i)
        field1.accessible_by_diagonal?(field2).should be_false
        field2.accessible_by_diagonal?(field1).should be_false
      end
    end 
  end

  it 'should be accessible by jump - 1' do
    field1 = ByzantionChess::Field.new(1,8)
    field2 = ByzantionChess::Field.new(2,6)
    field3 = ByzantionChess::Field.new(3,7)
    field1.accessible_by_jump?(field2).should be_true
    field2.accessible_by_jump?(field1).should be_true
    field1.accessible_by_jump?(field3).should be_true
    field3.accessible_by_jump?(field1).should be_true
  end  
  
  it 'should be accessible by jump - 2' do
    field1 = ByzantionChess::Field.new(8,8)
    field2 = ByzantionChess::Field.new(7,6)
    field3 = ByzantionChess::Field.new(6,7)
    field1.accessible_by_jump?(field2).should be_true
    field2.accessible_by_jump?(field1).should be_true
    field1.accessible_by_jump?(field3).should be_true
    field3.accessible_by_jump?(field1).should be_true
  end
  
  it 'should not be accessible by jump - 1' do
    field1 = ByzantionChess::Field.new(1,8)
    (1..8).each do |i|
      field2 = ByzantionChess::Field.new(4,i)
      field1.accessible_by_jump?(field2).should be_false
      field2.accessible_by_jump?(field1).should be_false
    end
  end

  it 'should return fields between two fields by vertical' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(1,8)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(1,i)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end

  end

  it 'should return fields between two fields by vertical' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(8,1)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(i,1)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end
  end

  it 'should return fields between two fields by diagonal' do
    field1 = ByzantionChess::Field.new(1,1)
    field2 = ByzantionChess::Field.new(8,8)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(i,i)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end
  end

  it 'should return fields between two fields by diagonal -2 ' do
    field1 = ByzantionChess::Field.new(1,8)
    field2 = ByzantionChess::Field.new(8,1)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(8-i+1,i)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end
  end

  it 'should return fields between two fields by diagonal - 3' do
    field2 = ByzantionChess::Field.new(1,1)
    field1 = ByzantionChess::Field.new(8,8)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(i,i)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end
  end

  it 'should return fields between two fields by diagonal - 4' do
    field2 = ByzantionChess::Field.new(1,8)
    field1 = ByzantionChess::Field.new(8,1)
    fields = ByzantionChess::Field.get_fields_between(field1, field2)
    fields.size.should eql 6
    (2..7).each do |i|
      field_between = ByzantionChess::Field.new(8-i+1,i)
      fields.select{|field| field.same_field?(field_between) }.size.should eql 1
    end
  end



end
