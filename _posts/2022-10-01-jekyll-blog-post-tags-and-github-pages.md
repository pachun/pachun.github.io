---
layout: post
title: "Jekyll Blog Post Tags and GitHub Pages"
tags: ["Ruby", "Gem"]
excerpt_separator: <!--end-of-excerpt-->
---

Tagging blog posts in jekyll is straightforward if you can use [plugins like this one][1]. However, [GitHub Pages only supports a set of whitelisted plugins][2] and I don't see any blog-post-tagging related helpers in that list. To make Jekyll tags work on GitHub Pages, you need to create an index page for each of your tags, which is painful.<!--end-of-excerpt-->

[I came up with a workaround that automates the process a bit and put it in a gem][3].

I say it automates the process _a bit_ because while it removes the monotony of needing to remember to manually create a page for each tag you've created and then keep them all up-to-date as you tag more posts, you have to remember to run a command before committing and pushing your updates to GitHub pages. It trades one thing for the other, but the other is a lot less brain-consuming.

It also lets you tag posts normally, without the need to make your tags url-safe, eg:

```
---
layout: default
tags: ["Hello World"]
---
```

Will work just fine and show in the browser at

```
your.site/tag/hello-world
```

Instead of having to hyphenate the tags for url-friendly concerns:

```
---
layout: default
tags: ["hello-world"]
---
```

... and then un-hyphenate them later before displaying them on the page.

I did find [helpful information elsewhere on the internet][4] explaining how to achieve the same goal with a Python script and a little setup if that's your cup of tea. Some of the setup was more involved than I felt should've been necessary (given what I wanted to do) so I tried to make something that only exposed a surface area that I felt was more relevant from a ruby-developer-writing-blog-posts perspective.

[Check it out][3]

[1]: https://github.com/pattex/jekyll-tagging
[2]: https://pages.github.com/versions/
[3]: https://github.com/pachun/update_tags
[4]: https://longqian.me/2017/02/09/github-jekyll-tag/
