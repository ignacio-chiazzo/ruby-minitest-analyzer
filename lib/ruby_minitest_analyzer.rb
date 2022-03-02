require "ruby_minitest_analyzer/version"
require_relative "ruby_minitest_analyzer/minitest_analyzer_config"
require_relative "ruby_minitest_analyzer/minitest_analyzer"
require_relative "ruby_minitest_analyzer/test_summary_presenter"

# REQUIRED_CLASSES = ["test/test_helper"]
# TEST_FILE_LOCATIONS = [
#   "test/**/*.rb",
# ]
# EXEMPTED_TEST_FILE_LOCATIONS = [] # File wihtin TEST_FILE_LOCATIONS are ignored by the analyzer.

module RubyMinitestAnalyzer
  class Error < StandardError; end
  # Your code goes here...
  
  def self.run!
    binding.pry
    # Load all the tests and required files such as test_helper.rb
    MinitestAnalyzerConfig.new.setup

    # Analyze the data and print the results
    puts "Analyzing!\n\n"
    duplicated_suites_data = MinitestsAnalyzer.analyze
    presenter = TestSummaryPresenter.new(duplicated_suites_data)
    presenter.present()
    Process.exit!
    puts "Finish"
  end
end
