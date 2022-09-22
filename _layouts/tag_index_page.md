---
layout: default
tag: Testing
---

{% assign posts = [] %}
{% for post in site.posts %}

{% if post.tags.include?(page.tag) %}
{% append post to posts %}

{% endif %}
{% endfor %}

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
    {% for post in posts %} {% include post.html post=post %} {% endfor %}
  </div>
</div>
