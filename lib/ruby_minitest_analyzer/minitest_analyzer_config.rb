# TODO require_relative MinitestAnalyzerConfigAbstract
require_relative "minitest_analyzer_config_abstract"
class MinitestAnalyzerConfig < MinitestAnalyzerConfigAbstract
  protected

  REQUIRED_CLASSES = ["test/test_helper"]
  TEST_FILE_LOCATIONS = [
    "test/**/*.rb",
  ]
  EXEMPTED_TEST_FILE_LOCATIONS = [] # File wihtin TEST_FILE_LOCATIONS are ignored by the analyzer.


  def test_classes
    test_files_locations.flat_map do |test_file|
      Dir[test_file]
    end
  end

  def required_classes
    REQUIRED_CLASSES
  end

  private

  def test_files_locations
    TEST_FILE_LOCATIONS
  end
end
