require 'spec_helper'

describe PgnFile do

  context 'loading pgn file' do
	it 'should initialize pgn_file object' do
		expect{PgnFile.new('filepath.pgn')}.not_to raise_error
	end

	it 'should not be able to load a file that is not a pgn' do
		expect{PgnFile.new('filepath.png')}.to raise_error
    end

    it 'should not load a file when path is incorrect' do
    	pgn_file = PgnFile.new('./spec/example_pgns/unexisting_filepath.pgn')
    	expect{pgn_file.load_and_parse_games}.to raise_error(ByzantionChess::InvalidPGNFile)
    end

	it 'should return error if file is empty' do
		pgn_file = PgnFile.new('./spec/example_pgns/empty_file.pgn')
		expect{pgn_file.load_and_parse_games}.to raise_error(ByzantionChess::InvalidPGNFile)
  	end
  end

  context 'parsing pgn file' do
  	it 'should parse a one game valid file' do
  		pgn_file = PgnFile.new('./spec/example_pgns/p.pgn')
  		expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 1
      game = pgn_file.games.first
      game.should be_kind_of(Game)
      game.header["White"].should eql 'Bitalzadeh Ali (NED)'
      game.header["Black"].should eql 'Zawadzka Jolanta (POL)'
      game.header["Result"].should eql '1-0'
      game.header["ECO"].should eql 'B80'
      game.header["Site"].should eql 'Deizisau (Germany)'
      game.header["Date"].should eql '2005.03.28'
      game.header["WhiteElo"].should eql "0"
      game.header["BlackElo"].should eql "2259"
      game.body.should_not be_nil
      game.body.should be_kind_of Sexp::PAllMovesWithResult
      @board = ByzantionChess::Board.new
      game.moves.each do |move|
        board_before_move = @board.dup
        expect{@board.make_move(move)}.not_to raise_error
        board_before_move.should_not eql @board
      end
      #TODO - check position
    end

    it 'should parse a one game valid file - 2' do
      pgn_file = PgnFile.new('./spec/example_pgns/beatka.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 1
      game = pgn_file.games.first
      game.should be_kind_of(Game)

      game.body.should_not be_nil
      game.body.should be_kind_of Sexp::PAllMovesWithResult
      @board = ByzantionChess::Board.new
      game.moves.each do |move|
        board_before_move = @board.dup
        puts move.inspect
        #expect{@board.make_move(move)}.not_to raise_error
        #board_before_move.should_not eql @board
      end
      #TODO - check position
    end


    it 'should read moves of parsed game' do
      pgn_file = PgnFile.new('./spec/example_pgns/b1.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 1
      game = pgn_file.games.first
      game.should be_kind_of(Game)
      game.convert_body_to_moves.should be_true
      game.moves.should_not be_empty
    end


  end
end