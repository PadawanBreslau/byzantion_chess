require 'spec_helper'

describe ByzantionChess::Piece do
  it 'should create a new pieces' do
    expect{ ByzantionChess::King.new(ByzantionChess::Field.new(1,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Queen.new(ByzantionChess::Field.new(1,ByzantionChess::D), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Rook.new(ByzantionChess::Field.new(1,ByzantionChess::A), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Bishop.new(ByzantionChess::Field.new(1,ByzantionChess::C), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Knight.new(ByzantionChess::Field.new(1,ByzantionChess::B), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Pawn.new(ByzantionChess::Field.new(2,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
  end

  it 'should  allow to_s on pieces' do
    expect(ByzantionChess::King.new(ByzantionChess::Field.new(1,ByzantionChess::E), ByzantionChess::WHITE).to_s).to eql('K')
    expect(ByzantionChess::Queen.new(ByzantionChess::Field.new(1,ByzantionChess::D), ByzantionChess::WHITE).to_s).to eql('Q')
    expect(ByzantionChess::Rook.new(ByzantionChess::Field.new(1,ByzantionChess::A), ByzantionChess::WHITE).to_s).to eql('R')
    expect(ByzantionChess::Bishop.new(ByzantionChess::Field.new(1,ByzantionChess::C), ByzantionChess::WHITE).to_s).to eql('B')
    expect(ByzantionChess::Knight.new(ByzantionChess::Field.new(1,ByzantionChess::B), ByzantionChess::WHITE).to_s).to eql('N')
    expect(ByzantionChess::Pawn.new(ByzantionChess::Field.new(2,ByzantionChess::E), ByzantionChess::WHITE).to_s).to eql('')
  end

  it 'should  allow to_s on pieces with locales' do
    expect(ByzantionChess::King.new(ByzantionChess::Field.new(1,ByzantionChess::E), ByzantionChess::WHITE).to_s(:pl)).to eql('K')
    expect(ByzantionChess::Queen.new(ByzantionChess::Field.new(1,ByzantionChess::D), ByzantionChess::WHITE).to_s(:pl)).to eql('H')
    expect(ByzantionChess::Rook.new(ByzantionChess::Field.new(1,ByzantionChess::A), ByzantionChess::WHITE).to_s(:pl)).to eql('W')
    expect(ByzantionChess::Bishop.new(ByzantionChess::Field.new(1,ByzantionChess::C), ByzantionChess::WHITE).to_s(:pl)).to eql('G')
    expect(ByzantionChess::Knight.new(ByzantionChess::Field.new(1,ByzantionChess::B), ByzantionChess::WHITE).to_s(:pl)).to eql('S')
    expect(ByzantionChess::Pawn.new(ByzantionChess::Field.new(2,ByzantionChess::E), ByzantionChess::WHITE).to_s(:pl)).to eql('')
  end
end
