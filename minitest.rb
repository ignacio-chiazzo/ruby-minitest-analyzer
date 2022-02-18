require "minitest/autorun"
require 'table_print'
require "set"

# Instructions

# 1) Copy and paste the analyzer file into a file in your app.
# 2) Modify the tests paths in the MinitestAnalyzerConfigurator object. If you need to tweak the configuration, take a look at MinitestAnalyzerConfig class
# 3) Run the analyzer file in your console:
# 4) Install table_print `gem install table_print`
# > ruby minitest_analyzer.rb

REQUIRED_CLASSES = [] # ["../../../test/test_helper"],
TEST_FILE_LOCATIONS = ["tests/tests_classes/*.rb"]

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
    required_classes.each { |f| require_relative(f) }

    test_classes.each do |f|
      next if f == current_location_source.first
      require_relative(f)
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
    self.class.instance_method(:setup).source_location
  end
end

class MinitestAnalyzerConfig < MinitestAnalyzerConfigAbstract
  protected

  def test_classes
    test_files_locations.flat_map do |test_file|
      Dir[test_file]
    end
  end

  def required_classes
    REQUIRED_CLASSES
  end

  private

  def test_files_locations
    TEST_FILE_LOCATIONS
  end
end

class SingleTestClassSummary
  def initialize(klass:, runnable_tests_count: , extra_executions_run: , extra_tests_executions_count:, subclasses:)
    @klass = klass
    @runnable_tests_count = runnable_tests_count
    @extra_executions_run = extra_executions_run
    @extra_tests_executions_count = extra_tests_executions_count
    @subclasses = subclasses
  end

  attr_accessor :klass, :runnable_tests_count, :extra_executions_run, :extra_tests_executions_count
  attr_reader :subclasses

  def add_subclass(subc)
    @subclasses << subc
  end
end

class TestSummaryPresenter
  def initialize(duplicated_suites)
    @duplicated_suites = duplicated_suites
    @total_extra_classes = @duplicated_suites.count
    @total_extra_tests = total_extra_tests_across_suites
  end

  def present
    puts "* Total duplicated tests that can be removed: #{@total_extra_tests}"
    puts "* Total classes with duplicated tests: #{@total_extra_classes} "
    puts "\nClasses that run the tests multiple times: \n\n"
    print_table_stats
    puts "\n\n"
  end

  private

  def print_table_stats
    list = @duplicated_suites.map { |klass_name, summary| summary }
    tp.set :max_width, 40
    tp(
      list,
      { Class: lambda { |s| s.klass.name } },
      "extra_executions_run",
      "runnable_tests_count",
      "extra_tests_executions_count",
      "klass"
    )
  end

  # Calculates all the extra tests that might be removed.
  def total_extra_tests_across_suites
    @duplicated_suites.sum { |klass, info| info.extra_tests_executions_count  }
  end
end

class MinitestsAnalyzer < Minitest::Test
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

# Load all the tests
MinitestAnalyzerConfig.new.setup

puts "Analyzing!\n\n"
duplicated_suites_data = MinitestsAnalyzer.analyze
presenter = TestSummaryPresenter.new(duplicated_suites_data)
presenter.present()
Process.exit!
puts "Finish"
