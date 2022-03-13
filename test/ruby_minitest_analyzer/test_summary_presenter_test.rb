# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/ruby_minitest_analyzer/minitest_analyzer'

class TestSummaryPresenterTest < Minitest::Test
  def test_present
    out = capture_subprocess_io do
      TestSummaryPresenter.new(duplicated_suites).present
    end

    assert_includes(
      out, "* Total duplicated tests that can be removed: 8\n" \
           "* Total classes with duplicated tests: 2 \n\n" \
           "Classes that run the tests multiple times: \n\n" \
           "CLASS NAME      | EXTRA_EXECUTIONS_RUN | RUNNABLE_TESTS_COUNT | EXTRA_TESTS_EXECUTIONS_COUNT | CLASS          \n" \
           "----------------|----------------------|----------------------|------------------------------|----------------\n" \
           "GrandParentTest | 4                    | 1                    | 4                            | GrandParentTest\n" \
           "Parent1Test     | 2                    | 2                    | 4                            | Parent1Test    \n" \
           "\n\n"
    )
  end

  private

  def duplicated_suites
    {
      'GrandParentTest' => SingleTestClassSummary.new(
        extra_executions_run: 4,
        extra_tests_executions_count: 4,
        klass: GrandParentTest,
        runnable_tests_count: 1,
        subclasses: [Parent1Test, Parent2Test, Child1Test, Child2Test]
      ),
      'Parent1Test' => SingleTestClassSummary.new(
        extra_executions_run: 2,
        extra_tests_executions_count: 4,
        klass: Parent1Test,
        runnable_tests_count: 2,
        subclasses: [Child1Test, Child2Test]
      )
    }
  end
end
