module ByzantionChess
  class WrongFieldException < Exception; end
  class WrongMoveException < Exception; end
  class InvalidMoveException < Exception; end
  class InvalidPawnPositionException < Exception; end
  class InvalidPieceException < Exception; end
  class InvalidCastlingException < Exception; end
  class BoardSetupException < Exception; end
  class ImpossibleCastleException < Exception; end
  class InvalidPGNFile < Exception; end
end
