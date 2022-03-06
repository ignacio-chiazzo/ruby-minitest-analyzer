require_relative "../test_helper"
require_relative "../../lib/ruby_minitest_analyzer/minitest_analyzer"

class MinitestAnalyzerTest < Minitest::Test
  def test_analyze
    require_all_files
    result = ::MinitestAnalyzer.analyze
    assert_equal(
      [ParentTest.name, ProductGrandParentTest.name, ProductParentTest.name].sort,
      result.keys.sort
    )
    
    parent_test_summary = result[ParentTest.name]
    assert_summary(
      summary: parent_test_summary,
      extra_executions_run: 1,
      extra_tests_executions_count: 1, 
      klass: ParentTest, 
      runnable_tests_count: 1, 
      subclasses: [BasicTest]
    )

    product_parent_test_summary = result[ProductParentTest.name]
    assert_summary(
      summary: product_parent_test_summary,
      extra_executions_run: 2,
      extra_tests_executions_count: 8,
      klass: ProductParentTest, 
      runnable_tests_count: 4, 
      subclasses: [ProductParentTest::TitleTest, ProductParentTest::TitleTestTest]
    )

    product_grand_parent_test_summary = result[ProductGrandParentTest.name]
    assert_summary(
      summary: product_grand_parent_test_summary,
      extra_executions_run: 4,
      extra_tests_executions_count: 4, 
      klass: ProductGrandParentTest, 
      runnable_tests_count: 1, 
      subclasses: [ProductParentTest, ProductParentTest::TitleTest, ProductParentTest::TitleTestTest, ProductParent2Test]
    )
  end

  class MinitestAnalyzerConfigExample < MinitestAnalyzerConfigAbstract
    def require_all_test_files
      # require test_helper
      require_relative("test/test_helper")
      
      # Require all the tests classes
      Dir["tests/tests_classes/*.rb"].each do |f|
        require_relative(f)
      end
    end
  end

  private


  def assert_summary(
    summary:,
    extra_executions_run:,
    extra_tests_executions_count:, 
    klass:, 
    runnable_tests_count:, 
    subclasses:
  )
    assert_equal(summary.extra_executions_run, extra_executions_run)
    assert_equal(summary.extra_tests_executions_count, extra_tests_executions_count)
    assert_equal(summary.klass, klass)
    assert_equal(summary.runnable_tests_count, runnable_tests_count)
    assert_equal(summary.subclasses, subclasses)
  end

  def require_all_files
    # require test_helpers
    require_relative("../test_helper")
    
    # require classes
    tests_files = Dir[File.expand_path("../../tests/tests_classes/*.rb", __dir__)]
    tests_files.each do |f|
      require_relative(f)
    end
  end
end