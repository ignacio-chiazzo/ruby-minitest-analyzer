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
      { Class: lambda { |s| s.klass.name.demodulize } },
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
