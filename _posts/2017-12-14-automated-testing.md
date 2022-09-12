---
layout: post
title: Automated Testing
---

The reason for having automated tests is to know whether or not code works. Working code fulfills product requirements.

> As listener Lindsey,
>
> When I tap on the ListenWith app icon,
>
> Then I see the names of all my Spotify playlists,
>
> So that I can select something to listen to.

Acceptance tests assure me these requirements are met. They automate what Lindsey does when she wants to see her Spotify playlists and then asserts what she expects.

1. Tap the ListenWith app icon
1. Assert that Lindey's Spotify playlist names are displayed

When this test passes we know the code works. When it fails, we know the code does not work. It's indicative of a fulfilled product requirement and that's reassuring.

Consider these two unit tests instead:

Test 1:

1. Tap the ListenWith app icon
1. Assert that `begin()` is called

Test 2:

1. Call `begin()`
1. Assert that Lindsey's Spotify playlist names are displayed

[Transitive][1] assertions are concessions when compared with acceptance tests because they're not indicative of working code. They're indicative of working code _which works in a certain way_.

> Why does it matter?

Tests may only either pass or fail. If, when they pass, we know that the code works in a certain way, then, when they fail, we either know that:

- The code does not work
- The code does not work the same way it used to work

In the prior example, if we rename `begin()` to `start()` and similarly update its callers, the code continues to work, yet both unit tests fail.

When the product requirements remain the same, the code continues working, and the test suite begins failing, we're creating waste.

If you've ever heard a coworker say,

> Don't test implementation details

... you've heard this message before.

## Concessions

There are pragmatic reasons to have unit tests.

Put them off as long as feasibly possible. When we need them, it's because they're _the most practical concession_. Eventually the ideal of an acceptance test will have a major shortcoming.

Do the best thing for today.

Test your product requirements, not your code.

[1]: https://en.wikipedia.org/wiki/Transitive_relation
