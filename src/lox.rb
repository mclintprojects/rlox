require "./src/scanner.rb"

class Lox
  def initialize(source_code_path)
    if source_code_path.nil? || source_code_path.empty?
      puts "Please provide a path to the source code"
      exit false
    else
      run_file(source_code_path)
    end
  end

  private

  def run_file(source_code_path)
    begin
      source_code = File.read(source_code_path)
      run(source_code)
    rescue Exception => e
      puts e.message
      exit(false)
    end
  end

  def run(source_code)
    scanner = Scanner.new(source_code)
    tokens = scanner.scan

    tokens.each { |token| puts token }
  end
end
