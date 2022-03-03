require_relative "test_helper"

class RubyMinitestAnalyzerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMinitestAnalyzer::VERSION
  end

  def test_run
    minitest_analyzer_config = MinitestAnalyzerConfig.new(
      required_classes_paths: ["./test/test_helper.rb"],
      test_files_locations_paths: ["./tests/tests_classes/basic_test.rb"], # Dir["tests/tests_classes/*.rb"],
      exempted_test_file_locations_paths: []
    )
    binding.pry

    # TODO: For some reason it's not picking up the test files location.
  
    ::RubyMinitestAnalyzer.run!(minitest_analyzer_config)
  end
end
