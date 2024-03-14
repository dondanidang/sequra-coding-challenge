# frozen_string_literal: true

# Ruby has nanosec precision
# Postgres has microsec precision
#
# => we force a microsec precison comparaison
RSpec::Matchers.class_eval do
  def change_time(receiver = nil, message = nil, &block)
    block ||= -> { receiver.send(message) }

    new_block =
      lambda do
        value = block.call

        return nil if value.nil?

        if value.respond_to?(:acts_like_time?)
          value.try(:change, nsec: value.usec * 1000)
        elsif value.nil?
          nil
        else
          raise 'Use change_time only for Time-like objects.'
        end
      end

    RSpec::Matchers::BuiltIn::Change.new(nil, nil, &new_block)
  end
end

RSpec::Matchers.define_negated_matcher(:not_change_time, :change_time)
