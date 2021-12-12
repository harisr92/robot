# frozen_string_literal: true

module Robot
  # Output chooses lib to out put
  module Output
    OUTPUTS = {
      shell: Printer
    }.freeze

    def self.find(strategy)
      (OUTPUTS[strategy.to_s.to_sym] || Printer)
    end

    def self.out(options)
      out_method = options.delete(:method).to_s
      find(out_method).out(options)
    end
  end
end
