# frozen_string_literal: true

Token = Struct.new(:re, :name) do
  def match(code)
    re.match(code)
  end
end

TOKENS = [
  [/\A[\s\t]/,         :WHITESPACE],
  [/\Afn/,             :DEFINE_FUNCTION],
  [/\A[\"\'].*[\"\']/, :STRING_LITERAL],
  [/\A\"/,             :DOUBLE_QUOTE],
  [/\A\,/,             :COMMA],
  [/\A\(/,             :OPEN_PAREN],
  [/\A\)/,             :CLOSE_PAREN],
  [/\A\+/,             :ADD_OPERATOR],
  [/\A[a-z][\w]*/,     :IDENTIFIER]
].map { Token.new(_1, _2) }.freeze

IGNORE = %i[WHITESPACE].freeze

# This class is responsible for tokenize SL's code
class Lexer
  attr_accessor :tokens

  def initialize
    @tokens = []
  end

  def tokenize(code)
    code.chomp!

    until code.empty?
      TOKENS.each do |token|
        chunk = token.match(code)
        next if chunk.nil?

        code = code[chunk.end(0)..-1]
        next if IGNORE.include? token.name

        tokens << [token.name, chunk[0]]
      end
    end
  end
end
