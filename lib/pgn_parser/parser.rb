require 'rubygems'
require 'treetop'

# defines classes of pgn tree elements
require File.expand_path(File.join(File.dirname(__FILE__), 'pgn_nodes.rb'))

class Parser
  #Defines rules according to which the game will be parsed
  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'pgn_rules.treetop')))
  @@parser = SexpParser.new

# parse - parsing pgn file
# INPUT: file_name - name of file (without path and extention)
# OUTPUT: tree og pgn game/home/padawan/Downloads/pgn1.pgn

  def self.parse(content)
    tree = @@parser.parse(content)
    if !tree
      puts @@parser.failure_reason
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end
    self.clean_tree(tree)
    #tree.elements.each{|el| puts el.text_value}
    self.read_games(tree)
  end

  private

  ## cleans tree, leaving only nodes from our classess
    def self.clean_tree(root_node)
      return if(root_node.elements.nil?)
      root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
      root_node.elements.each {|node| self.clean_tree(node) }
    end

    def self.read_games(root_node)
      return if(root_node.elements.nil?)
      root_node.elements.each{|game| self.parse_one_game(game) }
    end


    def self.parse_one_game(game_root)
      return if game_root.elements.nil?
      header = game_root.elements[0]
      body = game_root.elements[1]
      header_id = self.get_header_information(header) if header.class.name == "Sexp::PHeaderBody"

      self.get_game_body(body, header_id) if body.class.name == "Sexp::PAllMovesWithResult"
    end

    def self.get_header_information(header_root)
      return if header_root.elements.nil? || header_root.text_value == ""
      header_hash = {}
      header_root.elements.each do |header_line|
        parsed_header_line = header_line.selfparse header_line.text_value
        header_hash[parsed_header_line[0]] = parsed_header_line[1] unless self.wrong_format parsed_header_line[1]
      end
      header_hash
    end

    def self.get_game_body body_root, header_id
      return if body_root.elements.nil? || body_root.text_value == ""

      #body_id = GameBody.create_from_file header_id
      body_id = 0
      last_read_move = 0


      body_root.elements.each do |body_element|
        if body_element.class.name == "Sexp::PMove"
          last_read_move = Sexp::PMove.save_move(body_element, body_id)

        elsif body_element.class.name == "Sexp::PComment"
          #Sexp::PComment.save_comment(body_element, body_id, last_read_move)

        elsif body_element.class.name == "Sexp::PVariation"
          #depth = 1;
          #Sexp::PMove.save_variation(body_element, body_id, depth)
          
        elsif body_element.class.name == "Sexp::PCastle"
          #last_read_move = Sexp::PMove.save_move(body_element, body_id)

        end
      end


    end


    def self.wrong_format header_value
      header_value.empty? || header_value == "?" || header_value == "0"
    end
end