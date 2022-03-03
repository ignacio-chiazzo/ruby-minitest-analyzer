# TODO require_relative MinitestAnalyzerConfigAbstract
require_relative "minitest_analyzer_config_abstract"

class MinitestAnalyzerConfig < MinitestAnalyzerConfigAbstract
  def initialize(required_classes_paths: [], test_files_locations_paths: [], exempted_test_file_locations_paths: [])
    super
  end

  protected

  # REQUIRED_CLASSES = ["test/test_helper"]
  # TEST_FILE_LOCATIONS = [
  #   "test/**/*.rb",
  # ]
  # EXEMPTED_TEST_FILE_LOCATIONS = [] # File wihtin TEST_FILE_LOCATIONS are ignored by the analyzer.
  # Override this method if for some reason the 
  def require_all_test_files
    super
  end
end
