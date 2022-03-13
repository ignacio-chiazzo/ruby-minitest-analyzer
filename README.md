Ruby Minitests analyzer detects tests that run multiple times. In some cases, we want them to run them twice, but most of the time, we don't. 

### Example
See the following case. 

```ruby
require "minitest"
require "minitest/autorun"

class ProductParentTest < Minitest::Test
  def test_parent
    puts __method__
  end
end

class ProductTest < ProductParentTest
  def test_1
    puts __method__
  end

  def test_2
    puts __method__
  end
end
```
How many tests will we run if we run the `ProductTest` tests? 4! (yes, four). Try it!

```console
# Running:

test_2
test_parent
test_1
test_parent

Finished in 0.001218s, 3284.0724 runs/s, 0.0000 assertions/s.
4 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```

The reason is that `ProductTest` is a subclass of `ProductParentTest`.

## Installation

Add this line to your Application's Gemfile:

```ruby
gem 'ruby_minitest_analyzer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_minitest_analyzer

### How can I run the analyzer on my Application?

Run `ruby minitest.rb` it will analyze the tests within the project that uses Minitests.
1) Create a new test file.
2) Create a method `require_all_test_files` that will require all the tests files, including
the files needed to run the tests e.g. `test_helper.rb`.
3) Call `::RubyMinitestAnalyzer.run!(nil)`.
4) Run the file.


<details>
<summary>Example:</summary>
  
```ruby
  # I placed this file within /test
  
require_relative 'test_helper.rb'
require 'ruby_minitest_analyzer' 

def require_all_files
  # require test_helpers
  require_relative("test_helper")

  Dir[File.expand_path('**/*.rb', __dir__)].each do |f|
    require_relative(f)
  end
end

require_all_files
::RubyMinitestAnalyzer.run!(nil)
```
</details>

### Running the analyzer in your app.

Copy and paste the `minitest.rb` file. Modify the variables there and run the file.

```console
➜  rails-minitest-analyzer git:(main) ✗ ruby minitest.rb 
---------------Setting up---------------
Requiring files...
Total of 5 test classes to analyze. 
---------------Setup finished! Ready to analyze the tests---------------
Analyzing!

* Total duplicated tests that can be removed: 13
* Total classes with duplicated tests: 3 

Classes that run the tests multiple times: 

CLASS                  | EXTRA_EXECUTIONS_RUN | RUNNABLE_TESTS_COUNT | EXTRA_TESTS_EXECUTIONS_COUNT | KLASS                 
-----------------------|----------------------|----------------------|------------------------------|-----------------------
ParentTest             | 1                    | 1                    | 1                            | ParentTest            
ProductGrandParentTest | 4                    | 1                    | 4                            | ProductGrandParentTest
ProductParentTest      | 2                    | 4                    | 8                            | ProductParentTest     
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_minitest_analyzer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
