# frozen_string_literal: true

class MinitestAnalyzerConfig
  def initialize(required_classes_paths: [], test_files_locations_paths: [], exempted_test_file_locations_paths: [])
    @required_classes_paths = required_classes_paths
    @test_files_locations_paths = test_files_locations_paths
    @exempted_test_file_locations_paths = exempted_test_file_locations_paths
  end

  # An array of String containing the paths of all the required classes to run the tests.
  # E.g. ["../../../test/test_helper"]
  attr_reader :required_classes_paths

  # An array of String containing the paths of all the tests classes.
  # E.g: Dir["test/**/*.rb"]
  attr_reader :test_files_locations_paths

  # An array of String containing the  paths for all the files within test_file_locations
  # that are exempted from being required.
  attr_reader :exempted_test_file_locations_paths

  def setup
    print_tests_stats do
      require_all_test_files
    end
  end

  protected

  def require_all_test_files
    # require required_classes
    required_classes_paths.each do |f|
      require_relative_file(f)
    end

    # require test classes
    test_files_locations_paths.each do |f|
      next if f == current_location_source
      next if exempted_test_file_locations_paths.include?(f)

      require_relative_file(f)
    end
  end

  private

  def require_relative_file(file_path)
    require_relative(file_path)
  rescue LoadError => e
    puts "There was an error requiring a file: #{file_path}"
    raise e
  end

  def print_tests_stats
    puts "#{delimiter}Setting up#{delimiter}"
    puts 'Requiring files...'
    minitest_classes = yield
    print_analyzer_stats(minitest_classes)
    puts "#{delimiter}Setup finished! Ready to analyze the tests#{delimiter}\n"
  end

  def delimiter
    '-' * 15
  end

  def print_analyzer_stats(minitest_classes)
    puts "Total of #{minitest_classes.count} test classes to analyze. \n"
  end

  def current_location_source
    # Returns the current file location
    self.class.instance_method(:setup).source_location&.first
  end
end
