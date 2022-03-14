# frozen_string_literal: true

class SingleTestClassSummary
  # klass                 -> The test class analyzed
  # runnable_tests_count  -> The number of tests methods within the class.
  # class_descendant_count  -> The number of extra runs of the whole test class. Also known as the number of descendants.
  # extra_tests_execution_run -> The number of tests that run extra. E.G.

  def initialize(klass:, runnable_tests_count:, class_descendant_count:, extra_tests_executions_count:, subclasses:)
    @klass = klass
    @runnable_tests_count = runnable_tests_count
    @class_descendant_count = class_descendant_count
    @extra_tests_executions_count = extra_tests_executions_count
    @subclasses = subclasses
  end

  attr_accessor :klass, :runnable_tests_count, :class_descendant_count, :extra_tests_executions_count
  attr_reader :subclasses

  def add_subclass(subc)
    @subclasses << subc
  end
end
