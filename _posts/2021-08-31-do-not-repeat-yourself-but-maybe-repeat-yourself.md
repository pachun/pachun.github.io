---
layout: post
title: Do Not Repeat Yourself - But Maybe Repeat Yourself
tags: ["Refactoring", "DRY", "Diligent Maintenance"]
excerpt_separator: <!--end-of-excerpt-->
---

[Most of what I'm gonna say here has already been said really well by my favorite speaker, Sandi Metz.][1]

The Don't Repeat Yourself (DRY) principle is overemphasized and misapplied.

When you need a couple of lines of code that you've already written, copy and paste them. Seriously.<!--end-of-excerpt--> Creating a reused function to DRY up the code may reduce the number of lines but so does [golfing][2] and that doesn't produce easily maintainable code. Make things work in the way that will be easiest for the next person to understand and adapt.

Code should be DRY'd if it's being used for the same purpose every time it's used. If the repeated code gets changed in one place, will it surely need to be changed in the other? Recognizing those circumstances takes a bit of experience. When in doubt, prefer duplication over DRYing the code with a reused function. Some people like to use [the rule of three][3] for deciding when to DRY.

When conditionals start appearing in DRY'd code because one of the callers requires a little extra work be done and the others don't, it should be un-DRY'd. The conditionals will abstract which caller needs which things done and make the code harder to understand and adapt.

[1]: https://www.youtube.com/watch?v=8bZh5LMaSmE
[2]: https://en.wikipedia.org/wiki/Code_golf
[3]: https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)
