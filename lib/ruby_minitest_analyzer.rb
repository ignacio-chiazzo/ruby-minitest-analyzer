# frozen_string_literal: true

require 'ruby_minitest_analyzer/version'
require_relative 'ruby_minitest_analyzer/minitest_analyzer_config'
require_relative 'ruby_minitest_analyzer/minitest_analyzer'
require_relative 'ruby_minitest_analyzer/test_summary_presenter'

module RubyMinitestAnalyzer
  def self.run!(minitest_analyzer_config = nil, should_exit_process: false)
    load_test_files(minitest_analyzer_config)

    # Analyze the data and print the results
    puts "Analyzing!\n\n"
    duplicated_suites_data = MinitestAnalyzer.analyze
    presenter = TestSummaryPresenter.new(duplicated_suites_data)
    presenter.present
    Process.exit! if should_exit_process
    puts 'Finished'
  end

  def self.load_test_files(minitest_analyzer_config)
    # Load all the tests and required files such as test_helper.rb
    if minitest_analyzer_config.nil?
      puts('Not requiring files within the gem since tests files are loaded outside')
    else
      minitest_analyzer_config.setup
    end
  end
end
