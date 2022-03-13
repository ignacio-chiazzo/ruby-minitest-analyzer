# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/ruby_minitest_analyzer/minitest_analyzer'

class TestSummaryPresenterTest < Minitest::Test
  def test_present
    out = capture_subprocess_io do
      TestSummaryPresenter.new(duplicated_suites).present
    end

    assert_includes(
      out, "* Total duplicated tests that can be removed: 5\n" \
           "* Total classes with duplicated tests: 2 \n\n" \
           "Classes that run the tests multiple times: \n\n" \
           "CLASS NAME             | EXTRA_EXECUTIONS_RUN | RUNNABLE_TESTS_COUNT | EXTRA_TESTS_EXECUTIONS_COUNT | CLASS                 \n" \
           "-----------------------|----------------------|----------------------|------------------------------|-----------------------\n" \
           "ParentTest             | 1                    | 1                    | 1                            | ParentTest            \n" \
           "ProductGrandParentTest | 4                    | 1                    | 4                            | ProductGrandParentTest\n" \
           "\n\n"
    )
  end

  private

  def duplicated_suites
    {
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
      )
    }
  end
end
