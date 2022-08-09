module Helpers
  module Error
    def print_error(line:, message:)
      report_error(line: line, where: "", message: message)
    end

    private

    def report_error(line:, where:, message:)
      raise "[line: '#{line}'] Error #{where}: #{message}"
    end
  end
end
