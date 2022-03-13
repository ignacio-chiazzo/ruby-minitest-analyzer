# frozen_string_literal: true

require 'table_print'

class TestSummaryPresenter
  def initialize(duplicated_suites)
    @duplicated_suites = duplicated_suites
    @total_extra_classes = @duplicated_suites.count
    @total_extra_tests = total_extra_tests_across_suites
  end

  def present
    puts "* Total duplicated tests that can be removed: #{@total_extra_tests}"
    puts "* Total classes with duplicated tests: #{@total_extra_classes} "
    print_table_stats
    puts "\n\n"
  end

  private

  def print_table_stats
    if @duplicated_suites.empty?
      puts 'Nice Job! No duplicated tests found!!!'
      return
    end
    puts "\nClasses that run the tests multiple times: \n\n"

    list = @duplicated_suites.map { |_klass_name, summary| summary }
    tp.set :max_width, 40
    tp(
      list,
      { 'Class Name': ->(s) { demodulize_class(s.klass) } },
      'extra_executions_run',
      'runnable_tests_count',
      'extra_tests_executions_count',
      'Class': -> (s) { s.klass }
    )
  end

  def demodulize_class(klass)
    klass_name = klass.name
    if klass_name.respond_to?(:demodulize)
      klass_name.demodulize
    else
      klass_name
    end
  end

  # Calculates all the extra tests that might be removed.
  def total_extra_tests_across_suites
    @duplicated_suites.sum { |_klass, info| info.extra_tests_executions_count }
  end
end
