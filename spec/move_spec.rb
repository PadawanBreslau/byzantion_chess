require 'spec_helper'

describe ByzantionChess::Move do

  it 'should create move without information' do
    start_field = "a1"
    finish_field = "h8"
    expect{ByzantionChess::Move.new(start_field, finish_field, ByzantionChess::WHITE)}.not_to raise_error
  end

  it 'should create move with information' do
    start_field = "a1"
    finish_field = "h8"
    expect{@move = ByzantionChess::Move.new(start_field, finish_field, ByzantionChess::WHITE, 1)}.not_to raise_error
    @move.additional_info.should_not be_nil
    @move.number.should eql 1
    @move.color.should eql ByzantionChess::WHITE
  end

  it 'should create castle if start and end field is valid' do
    start_field = "e1"
    finish_field = "g1"
    expect{@castle = ByzantionChess::Castle.new(start_field, finish_field, ByzantionChess::WHITE, 1)}.not_to raise_error
    @castle.number.should eql 1
    @castle.color.should eql ByzantionChess::WHITE
  end

  it 'should not create castle if start and end field is not valid' do
    expect{ ByzantionChess::Castle.new("e1", "g8", ByzantionChess::WHITE, 1)}.to raise_error(ByzantionChess::InvalidMoveException)
    expect{ ByzantionChess::Castle.new("e1", "c8", ByzantionChess::WHITE, 1)}.to raise_error(ByzantionChess::InvalidMoveException)
    expect{ ByzantionChess::Castle.new("d1", "g8", ByzantionChess::WHITE, 1)}.to raise_error(ByzantionChess::InvalidMoveException)
    expect{ ByzantionChess::Castle.new("e1", "h1", ByzantionChess::WHITE, 1)}.to raise_error(ByzantionChess::InvalidMoveException)
  end

  it 'should create castle if start and end field is valid' do
    start_field = "e4"
    finish_field = "d5"
    expect{@en_passant = ByzantionChess::EnPassant.new(start_field, finish_field, ByzantionChess::WHITE, 1)}.not_to raise_error
    @en_passant.number.should eql 1
    @en_passant.color.should eql ByzantionChess::WHITE
  end

end