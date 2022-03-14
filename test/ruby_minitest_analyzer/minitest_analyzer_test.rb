# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/ruby_minitest_analyzer/minitest_analyzer'

class MinitestAnalyzerTest < Minitest::Test
  def test_analyze
    require_all_files
    result = ::MinitestAnalyzer.analyze

    assert_equal(
      [GrandParentTest.name, Parent1Test.name, Parent2Test.name].sort,
      result.keys.sort
    )

    parent_test_summary = result[GrandParentTest.name]
    assert_summary(
      summary: parent_test_summary,
      class_descendant_count: 5,
      extra_tests_executions_count: 5,
      klass: GrandParentTest,
      runnable_tests_count: 1,
      subclasses: [Parent1Test, Parent2Test, Child1Test, Child2Test, Child3Test]
    )

    parent_1_test_summary = result[Parent1Test.name]
    assert_summary(
      summary: parent_1_test_summary,
      class_descendant_count: 2,
      extra_tests_executions_count: 4,
      klass: Parent1Test,
      runnable_tests_count: 2,
      subclasses: [Child1Test, Child2Test]
    )

    parent_2_test_summary = result[Parent2Test.name]
    assert_summary(
      summary: parent_2_test_summary,
      class_descendant_count: 1,
      extra_tests_executions_count: 4,
      klass: Parent2Test,
      runnable_tests_count: 4,
      subclasses: [Child3Test]
    )
  end

  private

  def assert_summary(
    summary:,
    class_descendant_count:,
    extra_tests_executions_count:,
    klass:,
    runnable_tests_count:,
    subclasses:
  )
    assert_equal(class_descendant_count, summary.class_descendant_count)
    assert_equal(extra_tests_executions_count, summary.extra_tests_executions_count)
    assert_equal(klass, summary.klass)
    assert_equal(runnable_tests_count, summary.runnable_tests_count)
    assert_equal(subclasses.sort_by(&:name), summary.subclasses.sort_by(&:name))
  end

  def require_all_files
    # require test_helpers
    require_relative('../test_helper')

    # require classes
    tests_files = Dir[File.expand_path('../models/*.rb', __dir__)]
    tests_files.each do |f|
      require_relative(f)
    end
  end
end
