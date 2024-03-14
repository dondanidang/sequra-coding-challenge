# frozen_string_literal: true

# Concern for instance related to a money.
#
# Define <attribute>_money to get the Money version.
#
module Moneyable
  extend ActiveSupport::Concern

  class_methods do
    def with_money_on(*args)
      args.each do |attribute|
        define_method "#{attribute.to_s}_money" do
          value = public_send(attribute)

          return if value.nil?

          Money.from_amount(value)
        end
      end
    end
  end
end
