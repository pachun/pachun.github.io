#!/usr/bin/ruby

require "thor"
require "filewatcher"
require_relative "./update_tags"

# update_tags now --at tag --template _includes/tag_index_page.md
# update_tags now
#
# update_tags always --at tag --template _includes/tag_index_page.md
# update_tags always

class UpdateTagsCli < Thor
  DEFAULT_TAG_DIRECTORY = "tag"
  DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE = "_includes/tag_index_page.md"

  class_option :at,
    default: DEFAULT_TAG_DIRECTORY,
    desc: "the directory in which to put the tag index pages"

  class_option :template,
    default: DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE,
    desc: "the path to the file defining the tag index page template"

  desc "now", "update your jekyll blog's tag index pages"

  def now
    UpdateTags.update(
      tag_directory: options[:at],
      path_to_tag_index_page_template: options[:template],
    )
  end

  desc "always", "update your jekyll blog's tag index pages continuously"

  def always
    UpdateTags.update(
      tag_directory: options[:at],
      path_to_tag_index_page_template: options[:template],
    )

    Filewatcher.new(["_posts", options[:template]]).watch do |changes|
      UpdateTags.update(
        tag_directory: options[:at],
        path_to_tag_index_page_template: options[:template],
      )
    end
  end
end

UpdateTagsCli.start(ARGV)
