require_relative "test_helper"

class RubyMinitestAnalyzerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMinitestAnalyzer::VERSION
  end

  def test_it_does_something_useful
    assert false
  end

  def test_run
    ::RubyMinitestAnalyzer.run!
  end
end
