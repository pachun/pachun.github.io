---
layout: post
title: "Jekyll Blog Post Tags and GitHub Pages"
tags: ["Jekyll", "Ruby", "Liquid", "Github Pages"]
excerpt_separator: <!--end-of-excerpt-->
---

Tagging posts in jekyll is straightforward if you can use [plugins like this one][1]. However, [GitHub Pages only supports a set of whitelisted plugins][2] and I don't see any blog-post-tagging related helpers in that list. To make tags work with GitHub Pages, you need to create an index page for each of your tags, which is painful.

I came up with a workaround that automates the process - a bit. It lets you tag posts normally, without the need to make your tags url-safe, eg:

```
---
layout: default
tags: ["Hello World"]
---
```

Will work just fine instead of having to hyphenate the tags:

```
---
layout: default
tags: ["hello-world"]
---
```

[1]: https://github.com/pattex/jekyll-tagging
[2]: https://pages.github.com/versions/
