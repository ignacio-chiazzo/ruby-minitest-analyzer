require "minitest"
require "set"
require_relative "single_test_class_summary"

class MinitestAnalyzer < Minitest::Test
  class << self
    def analyze
      minitest_classes = load_minitest_classes.to_set
      duplicated_suites = {}

      minitest_classes.each_with_index do |child_a|

        child_a_runnable_tests = tests_methods(child_a)
        # If the parent doesn't have any runnable test then it does not have duplicated.
        next unless child_a_runnable_tests.count > 0

        child_a.ancestors.each do |ancestor_a|
          # ancestor_a
          #   child_a

          next if child_a == ancestor_a

          # skip if the ancestor is not a minitest class
          next unless minitest_classes.include?(ancestor_a)

          ancestor_a_runnable_tests = tests_methods(ancestor_a)

          # If the parent doesn't have any runnable test then it does not have duplicated.
          next unless ancestor_a_runnable_tests.count > 0

          # ancestor_a and child_a have runnable tests, there are duplicated tests.
          if duplicated_suites[ancestor_a.name]
            info = duplicated_suites[ancestor_a.name]
            info.extra_executions_run += 1
            info.extra_tests_executions_count += info.runnable_tests_count
            info.add_subclass(child_a)
            info
          else
            tests_count = ancestor_a_runnable_tests.count
            duplicated_suites_info =  SingleTestClassSummary.new(
              klass: ancestor_a,
              runnable_tests_count: tests_count,
              extra_executions_run: 1,
              extra_tests_executions_count: tests_count,
              subclasses: [child_a]
            )

            duplicated_suites[ancestor_a.name] = duplicated_suites_info
          end
        end
      end

      duplicated_suites
    end

    private

    def load_minitest_classes
      @minitest_classes ||= Minitest::Runnable.runnables.reject { |s| s.runnable_methods.empty? }
    end

    def tests_methods(klass)
      re = /test_/
      klass.public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end
