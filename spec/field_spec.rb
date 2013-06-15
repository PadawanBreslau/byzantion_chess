require 'spec_helper'

describe ByzantionChess::Field do
  
  it 'should not create a field and raise error' do
    expect{ ByzantionChess::Field.new('a',0)}.to raise_exception
    expect{ ByzantionChess::Field.new(10,0)}.to raise_exception
    expect{ ByzantionChess::Field.new(-1,0)}.to raise_exception
    expect{ ByzantionChess::Field.new(10,10)}.to raise_exception
    expect{ ByzantionChess::Field.new([],0)}.to raise_exception
  end
  
  it 'should create a field' do
    field = ByzantionChess::Field.new(1,0)
    field.vertical_line.should eql 1
    field.horizontal_line.should eql 0
  end
  
  
  it 'should be accessible by vertical line' do
    field1 = ByzantionChess::Field.new(1,0)
    field2 = ByzantionChess::Field.new(7,0)
    field1.accessible_by_line(field2).should be_true
  end
    
  it 'should be accessible by horizontal line' do
    field1 = ByzantionChess::Field.new(1,0)
    field2 = ByzantionChess::Field.new(1,7)
    field1.accessible_by_line(field2).should be_true
  end
  
  it 'should not be accessible by vertical or horizontal line' do
    field1 = ByzantionChess::Field.new(1,0)
    (1..7).each do |i| 
      field2 = ByzantionChess::Field.new(7,i)
      field1.accessible_by_line(field2).should be_false
    end 
  end 
  
  it 'should be accessible by diagonal line - 1' do
    field1 = ByzantionChess::Field.new(0,0)
    field2 = ByzantionChess::Field.new(7,7)
    field1.accessible_by_diagonal(field2).should be_true
    field2.accessible_by_diagonal(field1).should be_true
  end
  
  it 'should be accessible by diagonal line - 2' do
    field1 = ByzantionChess::Field.new(0,7)
    field2 = ByzantionChess::Field.new(7,0)
    field1.accessible_by_diagonal(field2).should be_true
    field2.accessible_by_diagonal(field1).should be_true
  end
  
  it 'should not be accessible by diagonal line - 1' do
    field1 = ByzantionChess::Field.new(0,7)
    (0..6).each do |i|  
      field2 = ByzantionChess::Field.new(6,i)
      field1.accessible_by_diagonal(field2).should be_false
      field2.accessible_by_diagonal(field1).should be_false
    end 
  end
  
  it 'should not be accessible by diagonal line - limit' do
    field1 = ByzantionChess::Field.new(0,7)
    field2 = ByzantionChess::Field.new(7,0)
    field1.accessible_by_diagonal(field2,1).should be_false
    field2.accessible_by_diagonal(field1,1).should be_false
  end
  
  it 'should be accessblie by jump - 1' do
    field1 = ByzantionChess::Field.new(0,7)
    field2 = ByzantionChess::Field.new(2,6)
    field1.accessible_by_jump(field2).should be_true
    field2.accessible_by_jump(field1).should be_true
  end  
  
  it 'should be accessblie by jump - 2' do
    field1 = ByzantionChess::Field.new(0,7)
    field2 = ByzantionChess::Field.new(1,5)
    field1.accessible_by_jump(field2).should be_true
    field2.accessible_by_jump(field1).should be_true
  end
  
  it 'should not be accessblie by jump - 1' do
    field1 = ByzantionChess::Field.new(0,7)
    (0..7).each do |i|
      field2 = ByzantionChess::Field.new(3,i)
      field1.accessible_by_jump(field2).should be_false
      field2.accessible_by_jump(field1).should be_false
    end
  end  
  

end