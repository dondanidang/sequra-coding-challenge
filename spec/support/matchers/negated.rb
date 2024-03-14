# frozen_string_literal: true

RSpec::Matchers.define_negated_matcher(:not_change, :change)
RSpec::Matchers.define_negated_matcher(:not_include, :include)
RSpec::Matchers.define_negated_matcher(:not_raise_error, :raise_error)
RSpec::Matchers.define_negated_matcher(:not_a_string_including, :a_string_including)
RSpec::Matchers.define_negated_matcher(:not_change_file, :change_file)
RSpec::Matchers.define_negated_matcher(:not_eq, :eq)
RSpec::Matchers.define_negated_matcher(:not_match, :match)
