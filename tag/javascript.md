---
layout: default
tag: Javascript
---

<div id="introduction-container">
  <div id="introduction">
    <h1 id="blog-title">{{ page.tag }} Posts</h1>
    <p id="blog-description">
      Posts about software development written by
      <a id="author-link" href="/about">Nick Pachulski</a>
    </p>
  </div>
</div>
<div id="blog-posts-container">
  <div id="blog-posts">
    {% for post in site.posts %}
      {% if post.tags contains page.tag %}
        {% include post.html post=post %}
      {% endif %}
    {% endfor %}
  </div>
</div>

