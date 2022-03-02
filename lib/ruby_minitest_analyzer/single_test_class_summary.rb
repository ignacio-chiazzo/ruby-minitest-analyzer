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