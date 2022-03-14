# frozen_string_literal: true

require_relative 'test_helper'

class RubyMinitestAnalyzerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMinitestAnalyzer::VERSION
  end

  def test_run_without_config
    require_all_files

    assert_output_summary(with_setup: false) do
      ::RubyMinitestAnalyzer.run!(nil)
    end
  end

  def test_run_with_passing_a_config
    tests_files = Dir[File.expand_path('models/*.rb', __dir__)]

    minitest_analyzer_config = MinitestAnalyzerConfig.new(
      required_classes_paths: [File.expand_path('test_helper.rb', __dir__)],
      test_files_locations_paths: tests_files,
      exempted_test_file_locations_paths: []
    )

    assert_output_summary do
      ::RubyMinitestAnalyzer.run!(minitest_analyzer_config)
    end
  end

  private

  def assert_output_summary(with_setup: true, &block)
    output = capture_subprocess_io(&block)
    setup_message = if with_setup
                      "---------------Setting up---------------\n" \
                        "Requiring files...\n" \
                        "Total of 6 test classes to analyze. \n" \
                        "---------------Setup finished! Ready to analyze the tests---------------\n" \
                    else
                      "Not requiring files within the gem since tests files are loaded outside\n"
                    end

    assert_includes(
      output.first,
      "#{setup_message}" \
      "Analyzing!\n\n" \
      "Analyzed a total of 9 classes.\n\n" \
      "* Total duplicated tests that can be removed: 13\n" \
      "* Total classes with duplicated tests: 3 \n\n" \
      "Classes that run the tests multiple times: \n\n" \
      "CLASS NAME      | CLASS_TEST_METHODS_COUNT | CLASS_DESCENDANT_COUNT | CLASS          \n" \
      "----------------|--------------------------|------------------------|----------------\n" \
      "GrandParentTest | 1                        | 5                      | GrandParentTest\n" \
      "Parent1Test     | 2                        | 2                      | Parent1Test    \n" \
      "Parent2Test     | 4                        | 1                      | Parent2Test    \n" \
      "\n\n" \
      "Finished\n"
    )
  end

  def class_summary
    @class_summary ||= {
      'GrandParentTest' => SingleTestClassSummary.new(
        class_descendant_count: 4,
        extra_tests_executions_count: 1,
        klass: GrandParentTest,
        runnable_tests_count: 1,
        subclasses: [Parent1Test, Parent2Test]
      ),
      'Parent1Test' => SingleTestClassSummary.new(
        class_descendant_count: 4,
        extra_tests_executions_count: 1,
        klass: Parent1,
        runnable_tests_count: 1,
        subclasses: [Child1Test, Child2Test]
      )
    }
  end

  def require_all_files
    # require test_helpers
    require_relative('test_helper')

    # require classes
    tests_files = Dir[File.expand_path('models/*.rb', __dir__)]
    tests_files.each do |f|
      require_relative(f)
    end
  end
end
