---
layout: post
title: Focus and Do as Little as Is Required
author: Nick Pachulski
tags: ["Agile", "Diligent Maintenance"]
excerpt_separator: <!--end-of-excerpt-->
---

I'm almost ashamed to say this because I was once so proud of it but here's a confession:

I don't always test drive my code anymore.

But the lesson learned from strictly only writing code which contributes to the passage of a failing test lasts: Stay focused and do as little as is required. You'll have less work today and someone - maybe you - will have easier work later.<!--end-of-excerpt-->

I recently did some work on an app which was a quiz. The stakeholders wanted to change the text of the quiz questions without involving a developer. I had an idea about how we'd build that feature and I expected it to take about half a day.

Then I learned that code intended to allow the quiz to be served in German, French or Spanish was riddled throughout, but the app itself didn't actually support any other languages. Preserving that "functionality" and allowing the stakeholders to edit the quiz questions took much longer.

Less than a day's work became a full week of work.

Don't write code because you're sure it'll be used later. You'll pay the price in maintenance costs until the value is actually realized - if it ever is.
