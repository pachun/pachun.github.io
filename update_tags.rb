require "filewatcher"
require "front_matter_parser"
require "fileutils"

class UpdateTags
  DEFAULT_TAG_DIRECTORY = "tag"
  DEFAULT_BLOG_POSTS_DIRECTORY = "_posts"
  DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE = "_includes/tag_index_page.md"

  def self.update(options = {})
    new(options).update
  end

  attr_reader :tag_directory,
    :blog_posts_directory,
    :path_to_tag_index_page_template

  def initialize(options)
    @tag_directory = options[:tag_directory] || DEFAULT_TAG_DIRECTORY

    @blog_posts_directory = \
      options[:blog_posts_directory] || DEFAULT_BLOG_POSTS_DIRECTORY

    @path_to_tag_index_page_template = \
      options[:path_to_tag_index_page_template] ||
      DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE
  end

  def update
    print "Updating tags..."
    delete_tag_pages
    create_tag_pages
    print " Done.\n"
  end

  private

  def delete_tag_pages
    FileUtils.rm_rf(tag_directory)
  end

  def create_tag_pages
    FileUtils.mkdir(tag_directory)

    tags.each do |tag|
      File.write(
        tag_index_page_path(tag),
        tag_index_page_source(tag),
      )
    end
  end

  def blog_post_filenames
    @blog_post_filenames ||= Dir.entries("./_posts") - [".", ".."]
  end

  def tags
    @tags ||= blog_post_filenames.inject([]) do |tags, blog_post_filename|
      tags += FrontMatterParser::Parser
        .parse_file(blog_post_file(blog_post_filename))
        .front_matter["tags"]
    end.uniq
  end

  def blog_post_file(blog_post_filename)
    "./#{blog_posts_directory}/#{blog_post_filename}"
  end

  def tag_index_page_path(tag)
    "#{tag_directory}/#{url_friendly_tag(tag)}.md"
  end

  def url_friendly_tag(tag)
    tag.downcase.split(" ").join("-")
  end

  def tag_index_page_front_matter_parser
    @tag_index_page_front_matter_parser ||= FrontMatterParser::Parser
      .parse_file(path_to_tag_index_page_template)
  end

  def tag_index_page_front_matter
    @tag_index_page_front_matter ||= \
      tag_index_page_front_matter_parser.front_matter.map do |key, value|
        "#{key}: #{value}"
      end.join("\n")
  end

  def tag_index_page_content
    @tag_index_page_content ||= tag_index_page_front_matter_parser.content
  end

  def injected_liquid_for_tag_index_page(tag)
    <<~INJECTED_LIQUID
      {% assign tag = "#{tag}" %}
      {% assign tagged_posts = "" | split: "" %}
      {% for post in site.posts %}
        {% if post.tags contains tag %}
          {% assign tagged_posts = tagged_posts | push: post %}
        {% endif %}
      {% endfor %}
    INJECTED_LIQUID
  end

  def tag_index_page_source(tag)
    <<~TAG_INDEX_PAGE
      ---
      #{tag_index_page_front_matter}
      ---

      #{injected_liquid_for_tag_index_page(tag)}

      #{tag_index_page_content}
    TAG_INDEX_PAGE
  end
end

UpdateTags.update

# update_tags(tag_directory)

# blog_posts_directory = "_posts"
# tag_index_page = "_includes/tag_index_page.md"
#
# Filewatcher.new(["_posts", "_includes/tag_index_page.md"]).watch do |changes|
#   update_tags(tag_directory)
# end
