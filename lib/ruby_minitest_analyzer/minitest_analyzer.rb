# frozen_string_literal: true

require 'minitest'
require 'set'
require_relative 'single_test_class_summary'

class MinitestAnalyzer < Minitest::Test
  class << self
    def analyze
      minitest_classes = minitest_classes_set
      duplicated_suites = {}

      minitest_classes.each do |klass|
        analyze_class(klass, duplicated_suites, minitest_classes)
      end

      duplicated_suites
    end

    private

    def analyze_class(klass, duplicated_suites_acc, minitest_classes)
      klass_runnable_tests = tests_methods(klass)

      # If the parent doesn't have any runnable test then it does not have duplicated.
      return unless klass_runnable_tests.count.positive?

      klass.ancestors.each do |klass_parent|
        # klass_parent
        #   klass

        next if klass == klass_parent

        # skip if the ancestor is not a minitest class
        next unless minitest_classes.include?(klass_parent)

        klass_parent_runnable_tests = tests_methods(klass_parent)

        # If the parent doesn't have any runnable test then it does not have duplicated.
        next unless klass_parent_runnable_tests.count.positive?

        # klass_parent and klass have runnable tests, there are duplicated tests.
        add_duplicated_test_to_hash(klass, klass_parent, klass_parent_runnable_tests, duplicated_suites_acc)
      end
    end

    def add_duplicated_test_to_hash(klass, klass_parent, klass_parent_runnable_tests, hash)
      if hash[klass_parent.name]
        info = hash[klass_parent.name]
        info.extra_executions_run += 1
        info.extra_tests_executions_count += info.runnable_tests_count
        info.add_subclass(klass)
        info
      else
        tests_count = klass_parent_runnable_tests.count
        hash_info = SingleTestClassSummary.new(
          klass: klass_parent,
          runnable_tests_count: tests_count,
          extra_executions_run: 1,
          extra_tests_executions_count: tests_count,
          subclasses: [klass]
        )

        hash[klass_parent.name] = hash_info
      end
    end

    def minitest_classes_set
      @minitest_classes_set ||= Minitest::Runnable.runnables.reject { |s| s.runnable_methods.empty? }
    end

    def tests_methods(klass)
      re = /test_/
      klass.public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end
