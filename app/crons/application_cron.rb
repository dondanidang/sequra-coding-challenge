# frozen_string_literal: true

module Crons
  class ApplicationService
    def self.run(*args, **kwargs)
      new(*args, **kwargs).send(:run)
    end
  end
end
