# Minitest Ruby redundant tests Analyzer

Ruby analyzer that detects tests that are running multiple times. In some cases, we want them to run them twice, but most of the times we don't. 

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
If we run the `ProductTest` tests, how many tests will it run? 4! (yes four). Try it!

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

### How can I run the analyzer?
run `ruby minitest.rb` it will analyze the tests within the project that uses Minitests.

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
