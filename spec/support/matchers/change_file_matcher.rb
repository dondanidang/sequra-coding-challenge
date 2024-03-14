# frozen_string_literal: true

module ChangeFileMatcher
  class ChangeFile < RSpec::Matchers::BuiltIn::Change
    def initialize(file_path)
      block = -> { File.exist?(file_path) ? File.read(file_path) : nil }
      super(File, "read(#{file_path})", &block)
    end

    def diffable?
      true
    end
  end

  def change_file(file_path)
    ChangeFile.new(file_path)
  end
end
