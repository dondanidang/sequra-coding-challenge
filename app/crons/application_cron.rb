# frozen_string_literal: true

class ApplicationService
  def self.run(*args, **kwargs)
    new(*args, **kwargs).send(:run)
  end
end
