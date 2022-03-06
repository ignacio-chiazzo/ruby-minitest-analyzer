$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../tests", __FILE__)
$LOAD_PATH.unshift File.expand_path("../tests", __FILE__)
require "ruby_minitest_analyzer"

require "minitest/autorun"
require "pry"
# require_relative()
# binding.pry
# Dir["tests/tests_classes/*.rb"].each { |f| require_relative f }
# Dir["lib/ruby_minitest_analyzer"].each { |f| require_relative f }

# require_relative("test/test_helper")
      
# Dir["tests/tests_classes/*.rb"].each do |f|
#   require_relative(f)
# end

