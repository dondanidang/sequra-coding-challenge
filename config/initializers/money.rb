# frozen_string_literal: true

Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.default_currency = Money::Currency.new("EUR")
