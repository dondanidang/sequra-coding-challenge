# frozen_string_literal: true

class ApplicationService
  def self.call(*args, **kwargs)
    new(*args, **kwargs).send(:call)
  end

  def self.call!(*args, **kwargs)
    new(*args, **kwargs).send(:call!)
  end
end
