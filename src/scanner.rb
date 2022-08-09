require "./src/helpers/error.rb"

class Scanner
  include Helpers::Error

  class TokenType
    LEFT_PAREN = :left_paren
    RIGHT_PAREN = :right_paren
    LEFT_BRACE = :left_brace
    RIGHT_BRACE = :right_brace
    COMMA = :comma
    DOT = :dot
    MINUS = :minus
    PLUS = :plus
    SEMICOLON = :semicolon
    SLASH = :slash
    STAR = :star
    BANG = :bang
    BANG_EQUAL = :bang_equal
    EQUAL_EQUAL = :equal_equal
    EQUAL = :equal
    GREATER = :greater
    GREATER_EQUAL = :greater_equal
    LESS = :less
    LESS_EQUAL = :less_equal

    IDENTIFIER = :identifier
    STRING = :string
    NUMBER = :number
    FALSE = :false
    TRUE = :true

    AND = :and
    OR = :or

    FOR = :for
    WHILE = :while

    IF = :if
    ELSE = :else

    PRINT = :print
    RETURN = :return

    SUPER = :super
    THIS = :this
    VAR = :var
    NIL = :nil

    FUNCTION = :function
    KLASS = :klass

    EOF = :eof
  end

  class Token
    attr_reader :type, :lexeme, :literal, :line

    def initialize(type:, lexeme: nil, literal: nil, line: nil)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @line = line
    end

    def to_s
      "#{type} #{lexeme} #{literal}"
    end
  end

  attr_accessor :source_code, :tokens, :start, :line, :current

  def initialize(source_code)
    @source_code = source_code
    @tokens = []
    @current = 0
    @start = 0
    @line = 1
  end

  def scan
    loop do
      break if eof?
      start = current

      scan_tokens
    end

    tokens.push(Token.new(type: TokenType::EOF, lexeme: "", line: line))
  end

  private

  def scan_tokens
    element = source_code[current]
    @current += 1

    case element
    when "("
      add_token(TokenType::LEFT_PAREN)
    when ")"
      add_token(TokenType::RIGHT_PAREN)
    when "{"
      add_token(TokenType::LEFT_BRACE)
    when "}"
      add_token(TokenType::RIGHT_BRACE)
    when "."
      add_token(TokenType::DOT)
    when ","
      add_token(TokenType::COMMA)
    when "-"
      add_token(TokenType::MINUS)
    when "+"
      add_token(TokenType::PLUS)
    when "*"
      add_token(TokenType::STAR)
    when "/"
      add_token(TokenType::SLASH)
    when "!"
      add_token(match?("=") ? TokenType::BANG_EQUAL : TokenType::BANG)
    when "="
      add_token(match?("=") ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
    when ">"
      add_token(match?("=") ? TokenType::GREATER_EQUAL : TokenType::GREATER)
    when "<"
      add_token(match?("=") ? TokenType::LESS_EQUAL : TokenType::LESS)
    when " ", "\r", "\t"
      return
    when "\n"
      @line += 1
    when "\""
      chomp_string_literal
    else
      print_error(line: line, message: "#{line} Unexpected character")
    end
  end

  def chomp_string_literal
    loop do
      if source_code[current] == "\""
        add_token(TokenType::STRING, source_code[(start + 1)..(current - 1)])
        @current += 1
        break
      elsif eof?
        print_error(line: line, message: "#{line} Unterminated string")
        break
      end

      @current += 1
    end
  end

  def match?(literal)
    return false if eof?

    if source_code[@current + 1] == literal
      @current += 1
      return true
    else
      return false
    end
  end

  def add_token(token_type, literal)
    lexeme = source_code[start..current]
    tokens.push(Token.new(type: token_type, lexeme: lexeme, literal: literal, line: nil))
  end

  def eof?
    current >= source_code.length
  end
end
