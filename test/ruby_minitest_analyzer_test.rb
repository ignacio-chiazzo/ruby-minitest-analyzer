# frozen_string_literal: true

require_relative 'test_helper'

class RubyMinitestAnalyzerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RubyMinitestAnalyzer::VERSION
  end

  # def test_run
  #   test_files_locations_paths = Dir["tests/tests_classes/*.rb"].map do |f|
  #     File.expand_path(f, __dir__)
  #   end

  #   # test/test_helper.rb
  #   minitest_analyzer_config = MinitestAnalyzerConfig.new(
  #     required_classes_paths: [File.expand_path("test/test_helper.rb", __dir__)],
  #     test_files_locations_paths: test_files_locations_paths, #
  #     exempted_test_file_locations_paths: []
  #   )

  #   # TODO: For some reason it's not picking up the test files location.

  #   ::RubyMinitestAnalyzer.run!(minitest_analyzer_config)
  # end

  # def test_run_with_a_config_class
  #   config = MinitestAnalyzerConfigExample.new
  #   config.setup
  #   ::RubyMinitestAnalyzer.run!(config)

  #   # TODO: For some reason it's not picking up the test files location.

  #   ::RubyMinitestAnalyzer.run!(minitest_analyzer_config)
  # end

  def test_run_workaround
    require_all_files
    # ::RubyMinitestAnalyzer.run!(nil)
  end

  class MinitestAnalyzerConfigExample < MinitestAnalyzerConfigAbstract
    def require_all_test_files
      # require test_helper
      require_relative('test/test_helper')

      # Require all the tests classes
      Dir['test/models/*.rb'].each do |f|
        require_relative(f)
      end
    end
  end

  private

  def require_all_files
    # require test_helpers
    require_relative('test_helper')

    # require classes
    tests_files = Dir[File.expand_path('models/*.rb', __dir__)]
    tests_files.each do |f|
      require_relative(f)
    end
  end
end
