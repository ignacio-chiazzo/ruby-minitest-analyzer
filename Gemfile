# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group(:test) do
  gem('pry', '~> 0.13.1')
  gem('pry-byebug', '~> 3.9.0')
  gem('rubocop', '~> 1.25.1')
  gem('rubocop-minitest', '~> 0.17.2')
end

gem('table_print')

# Specify your gem's dependencies in ruby_minitest_analyzer.gemspec
gemspec
