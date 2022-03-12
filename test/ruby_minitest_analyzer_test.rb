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
      "Analyzed a total of 10 classes.\n\n" \
      "* Total duplicated tests that can be removed: 13\n" \
      "* Total classes with duplicated tests: 3 \n\n" \
      "Classes that run the tests multiple times: \n\n" \
      "CLASS                  | EXTRA_EXECUTIONS_RUN | RUNNABLE_TESTS_COUNT | EXTRA_TESTS_EXECUTIONS_COUNT | KLASS                 \n" \
      "-----------------------|----------------------|----------------------|------------------------------|-----------------------\n" \
      "ParentTest             | 1                    | 1                    | 1                            | ParentTest            \n" \
      "ProductGrandParentTest | 4                    | 1                    | 4                            | ProductGrandParentTest\n" \
      "ProductParentTest      | 2                    | 4                    | 8                            | ProductParentTest     \n\n\n" \
      "Finish\n"
    )
  end

  def class_summary
    @class_summary ||= {
      'ParentTest' => SingleTestClassSummary.new(
        extra_executions_run: 1,
        extra_tests_executions_count: 1,
        klass: ParentTest,
        runnable_tests_count: 1,
        subclasses: [BasicTest]
      ),
      'ProductGrandParentTest' => SingleTestClassSummary.new(
        extra_executions_run: 4,
        extra_tests_executions_count: 4,
        klass: ProductGrandParentTest,
        runnable_tests_count: 1,
        subclasses: [ProductParent2Test, ProductParentTest, ProductParentTest::TitleTest,
                     ProductParentTest::TitleTestTest]
      ),
      'ProductParentTest' => SingleTestClassSummary.new(
        extra_executions_run: 2,
        extra_tests_executions_count: 8,
        klass: ProductParentTest,
        runnable_tests_count: 4,
        subclasses: [ProductParentTest::TitleTest, ProductParentTest::TitleTestTest]
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
