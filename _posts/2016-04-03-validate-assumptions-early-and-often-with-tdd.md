---
layout: post
title: Validate Assumptions Early and Often With TDD
excerpt_separator: <!--end-of-excerpt-->
---

Let's test drive an even number function<!--end-of-excerpt-->:

```ruby
it "returns true when passed an even number" do
  even = even?(2)
  expect(even).to be(true)
end
```

Hardcode the return value:

```ruby
def even?(num)
  return true
end
```

The test passes and the code disrespects the argument.

It's a tautology.

... And that's good. If we expect new outcomes given new input we have to say so in a test. Otherwise, [our tests may pass while our code breaks](#todo). Assumptions need to be validated often.

## Untested Assumptions

Pretend we wrote this code to make our lonesome test pass:

```ruby
def even?(num)
  (num % 2) == 0
end
```

This is worse than before.

Six months from now, the name of this function has changed and new people are maintaining the code. It looks very different, to the point where its original purpose is no longer obvious. Its name isn't `even?` anymore and it's 20 lines long now.

Developer Diane comes along with the intention of adding a new feature to the app. She changes what used to be named our `even?` function to have this line at the bottom:

```ruby
return true
```

She runs the tests and they all pass. However, back when we added our feature without properly driving it out with tests, we added code contingent upon the assumption that `even?` also returned false when passed an odd number:

```ruby
def qualifies_for_refund?(customer)
  return (
    customer.is_gold_member? ||
    even?(customer.some_statistic)
  )
end
```

We wrote code dependent upon an untested assumption and Diane was able to invalidate it without causing any tests to fail even though she properly test drove her feature. Now every customer qualifies for a refund and it's our fault.

We should not be able to delete any code without breaking a test. If we can delete code without breaking a test, that code is the embodiment of untested assumptions. It may not even be used, increasing the ramp up cost for new team members and maintenance overhead for everyone else.

## Conclusion

When we last left our code, we were here:

```ruby
it "returns true when passed an even number" do
  even = even?(2)
  expect(even).to be(true)
end

def even?(num)
  return true
end
```

Now let's write our other, long awaited test:

```ruby
it "returns false when passed an odd number" do
  even = even?(1)
  expect(even).to be(false)
end
```

Only now do we _need_ to make the return value of `even?` contingent upon its argument.

Only now _should_ we make the return value of `even?` contingent upon its argument.

```ruby
def even?(num)
  num % 2 == 0
end
```

Validate assumptions early and often with TDD.
