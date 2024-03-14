# frozen_string_literal: true

class ApplicationCron
  def self.run(*args, **kwargs)
    new(*args, **kwargs).send(:run)
  end
end
