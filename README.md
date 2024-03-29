# Ruby Minitest Analyzer

Minitest uses Ruby classes, **if a Minitest class inherits from another class, it will also inherit its methods causing Minitest to run the parent's tests twice.**
In some cases, we want them to run them twice, but most of the time, we don't.  

Ruby Minitest Analyzer will analyze your Minitest classes and detect any duplicate test run.

![Untitled-2022-03-13-1106](https://user-images.githubusercontent.com/11672878/158284753-08ea962f-9ac6-46a6-acec-e2464a258a41.png)

**This Library is explained in detail in [this Post](https://ignaciochiazzo.medium.com/dont-run-your-ruby-minitest-classes-twice-988645662cdb)**

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

Note: I added a [new cop to Rubocop](https://github.com/rubocop/rubocop-minitest/pull/164) that checks for duplicated run tests. The cop has some limitations that this library solves. For example, in the cop, the classes should be in the same file. 

**More details in [this Post](https://ignaciochiazzo.medium.com/dont-run-your-ruby-minitest-classes-twice-988645662cdb)**

Other scenarios were it doesn't create duplicated tests:

<details><summary>When the class is under a parent Minitest class but it doesn't inherit from it.</summary>

```ruby
class A < Minitest
  test xyz do 
  end

  class B < Minitest
    test bar do 
    end
  end

  class C < Minitest
    test foo do 
    end
  end
end
```

</details>

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

1) Create a new test `minitest_analyzer.rb` file.
2) Create a method `require_all_test_files` requiring all the tests files, including
the files needed to run the tests e.g. `test_helper.rb`. See the example below.
3) Call `::RubyMinitestAnalyzer.run!(nil)`.
4) Run the file.

<details>
<summary> minitest_analyzer.rb example:</summary>
  
```ruby
# I placed this file within /test
  
require_relative 'test_helper.rb'
require 'ruby_minitest_analyzer' 

def require_all_files
  # require test_helpers
  require_relative("test_helper")

  # require tests classes
  Dir[File.expand_path('**/*.rb', __dir__)].each do |f|
    require_relative(f)
  end
end

require_all_files
::RubyMinitestAnalyzer.run!(nil)
```
</details>

Running the file example:

```console
➜  rails-minitest-analyzer git:(main) ✗ ruby minitest.rb 
---------------Setting up---------------
Requiring files...
Total of 6 test classes to analyze. 
---------------Setup finished! Ready to analyze the tests---------------
Analyzing!

Analyzed a total of 6 classes.
      
* Total duplicated tests that can be removed: 12
* Total classes with duplicated tests: 3 
      
Classes that run the tests multiple times: 

CLASS NAME      | CLASS_TEST_METHODS_COUNT | CLASS_DESCENDANT_COUNT | EXTRA_TESTS_EXECUTIONS_COUNT 
----------------|--------------------------|------------------------|------------------------------
GrandParentTest | 1                        | 5                      | 5                            
Parent1Test     | 2                        | 2                      | 4                            
Parent2Test     | 3                        | 1                      | 3                            

Finished!  
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_minitest_analyzer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
