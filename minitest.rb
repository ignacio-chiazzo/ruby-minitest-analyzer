require "minitest/autorun"
require "pry"
require 'pry-byebug'
require 'table_print'

require_relative 'tests/models/product'
require_relative 'tests/tests_classes/product_grand_parent_test'
require_relative 'tests/tests_classes/product_parent_test'

class SingleClassDuplicatedTestsSummary
  def initialize(klass:, runnable_tests_count: , extra_executions_run: , extra_tests_executions_count:, subclasses:)
    @klass = klass
    @runnable_tests_count = runnable_tests_count 
    @extra_executions_run = extra_executions_run
    @extra_tests_executions_count = extra_tests_executions_count
    @subclasses = subclasses
  end

  attr_accessor :klass, :runnable_tests_count, :extra_executions_run, :extra_tests_executions_count, :subclasses

  def add_subclass(subc)
    @subclasses << subc
  end
end

class MinitestsAnalyzer < Minitest::Test
  class << self
    def analyze
      minitests_classes = load_minitests_classes
      duplicated_suites = {}

      minitests_classes.each_with_index do |a|
        minitests_classes.each_with_index do |b|
          next if a == b 
          
          # b < a.  a -> parent, b -> child
          if b.ancestors.include?(a)
            parent_tests_runnable =  tests_methods(a)
            if duplicated_suites[a.name]
              info = duplicated_suites[a.name]
              info.extra_executions_run += 1
              info.extra_tests_executions_count += info.runnable_tests_count
              info.add_subclass(b)
              info
            else
              tests_count = parent_tests_runnable.count
              duplicated_suites_info =  SingleClassDuplicatedTestsSummary.new(
                klass: a,
                runnable_tests_count: tests_count, 
                extra_executions_run: 1, 
                extra_tests_executions_count: tests_count, 
                subclasses: [b]
              )

              duplicated_suites[a.name] = duplicated_suites_info
            end
          end
        end
      end

      analyze_data(duplicated_suites)
    end

    private

    def load_minitests_classes
      @minitests_classes ||= Minitest::Runnable.runnables.reject { |s| s.runnable_methods.empty? }
    end

    def prints_message(duplicated_suites, total_extra_classes, total_extra_tests)
      puts "\n\n"
      puts "*" * 50
      puts "Total duplicated tests that can be removed: #{total_extra_tests}"
      puts "Total classes with duplicated tests: #{total_extra_classes} "
      puts "-" * 50
      puts "\nClasses that run the tests multiple times: \n"

      list = duplicated_suites.map { |klass_name, summary| summary }
      tp list, "klass", "extra_executions_run", "runnable_tests_count", "extra_tests_executions_count"
      puts "*" * 50
      puts "\n\n"
    end

    def analyze_data(duplicated_suites)
      total_extra_tests  = total_extra_tests_across_suites(duplicated_suites)
      total_extra_classes = duplicated_suites.count
      prints_message(duplicated_suites, total_extra_classes, total_extra_tests)
    end

    def total_extra_tests_across_suites(duplicated_suites)
      duplicated_suites.sum { |klass, info| info.extra_tests_executions_count  }
    end

    # def descendants(klass)
    #   ObjectSpace.each_object(Class).select { |k| k < klass }
    # end

    def tests_methods(klass)
      re = /test_/
      klass.public_instance_methods(true).grep(re).map(&:to_s)
    end
  end
end

MinitestsAnalyzer.analyze