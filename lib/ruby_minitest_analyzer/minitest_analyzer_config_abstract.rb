class MinitestAnalyzerConfigAbstract
  def setup
    print_tests_stats do
      require_all_test_files
    end
  end

  protected

  # Returns an array of String containing all the tests classes. E.g:
  # Dir["test/**/*.rb"]
  def test_classes
    raise NotImplementedError, "test_classes must be implemented"
  end

  # Returns an array of String containing all the required classes to run the tests. E.g.
  # ["../../../test/test_helper"]
  def required_classes
    raise NotImplementedError, "required_classes must be implemented"
  end

  private

  def require_all_test_files
    required_classes.each do |f|
      require_relative_file(f)
    end

    test_classes.each do |f|
      next if f == current_location_source
      next if EXEMPTED_TEST_FILE_LOCATIONS.include?(f)
      
      require_relative_file(f)
    end
  end

  def require_relative_file(f)
    begin
      require_relative(f)
    rescue => e
      "There was an error requiring the file: #{f}"
      puts e
    end
  end

  def print_tests_stats(&block)
    puts "-" * 15 + "Setting up" + "-" * 15
    puts "Requiring files..."
    minitest_classes = yield
    print_analyzer_stats(minitest_classes)
    puts "-" * 15 + "Setup finished! Ready to analyze the tests" + "-" * 15 + "\n"
  end

  def print_analyzer_stats(minitest_classes)
    puts "Total of #{minitest_classes.count} test classes to analyze. \n"
  end

  def current_location_source
    # Returns the current file location
    self.class.instance_method(:setup).source_location&.first
  end
end
