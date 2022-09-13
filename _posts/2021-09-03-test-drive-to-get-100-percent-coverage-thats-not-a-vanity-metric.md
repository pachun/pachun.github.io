---
layout: post
title: "Test Drive to Get 100% Coverage That's Not a Vanity Metric"
tags: ["Testing", "Test Driven Development", "Diligent Maintenance"]
excerpt_separator: <!--end-of-excerpt-->
---

A vanity metric looks good on paper but doesn't inform future strategies. It falsely increases confidence.

Code coverage can be a vanity metric.

100% test coverage means that the test suite runs every line of production code. That doesn't mean it exercises the code's entire intent. <!--end-of-excerpt--> Here's an example:

```ruby
require "rspec"

def even?(number)
  number % 2 == 0
end

describe "even?" do
  it "returns whether or not the argument is an even number" do
    expect(even?(2)).to be(true)
  end
end
```

There's 100% code coverage here, but the code's intent wasn't properly test driven. Unfortunately there's no metric which informs whether or not the coverage value resulted from a test driven process. If you can delete a line of code without breaking a test, then either a mistake was made or the code wasn't test driven. Knowing the authors helps. ([I've written a little bit about how to properly test drive][1] and [which types of tests I find most valuable][2]). The test driven process results in some _fantastic_ benefits:

The coverage value is 100% and you can trust it. It's not a vanity metric. Refactoring becomes a breeze.

Test driving doesn't only mean a test was written before production code. It means every line of production code contributed directly to the passage of a failing test. It did no more than was necessary to either progress the test's failure or make it pass. These are tests you can trust. Any change that appears to be a straightforward refactor, but in fact isn't, will be highlighted by a failing test.

The test suite is a living executable explaining the intent of the product.

Understanding thousands of lines of code that were written by a stranger is daunting. Imagine the code had been test driven and further imagine that coverage was at 100%. In this situation, if a line if code doesn't seem to make sense, delete it and run the test suite. One or more tests will fail. The title of the failing test will be a human readable explanation of the product team's intent when they decided to add the feature to which the deleted line of code contributes. The body of the failing test will be a technical example of its usage. This benefit alone contributes wildly to maintenance costs. Developers picking up work on a project which hasn't been touched in months will have much quicker ramp up times. Switching to new developers will also require less onboarding time.

The intended features are built up front.

Since a failing test is required to write any production code, new features require specific details up front. That'll make for some tough conversations but better to have those conversations earlier than follow through codifying the development team's misunderstandings.

To the people who assert that the benefit of 100% test coverage is, without exception, vanity: You have a point, but it isn't always true. It depends on the path to 100% coverage.

All this said, I don't always strictly test drive my code anymore. I think there are cases where it doesn't help as much as it does in others. I'll definitely be writing about those exceptions soon.

[1]: https://pachulski.dev/posts/test-driving.html
[2]: https://pachulski.dev/posts/automated-testing.html
