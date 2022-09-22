---
layout: default
---

<div id="introduction-container">
  <div id="introduction">
    <h1 id="blog-title">{{ tag }} Posts</h1>
    <p id="blog-description">
      Posts about software development written by
      <a id="author-link" href="/about">Nick Pachulski</a>
    </p>
  </div>
</div>
<div id="blog-posts-container">
  <div id="blog-posts">
    {% for post in tagged_posts %}
      {% include post.html post=post %}
    {% endfor %}
  </div>
</div>
