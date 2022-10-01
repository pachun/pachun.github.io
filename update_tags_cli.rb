#!/usr/bin/ruby

require "thor"
require_relative "./update_tags"

# update_tags --at tag --watch

class UpdateTagsCli < Thor
  DEFAULT_TAG_DIRECTORY = "tag"
  DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE = "_includes/tag_index_page.md"

  option :at,
    default: DEFAULT_TAG_DIRECTORY,
    desc: "the directory in which to put the tag index pages"

  option :template,
    default: DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE,
    desc: "the path to the file defining the tag index page template"

  desc "now", "update your jekyll blog's tag index pages"

  def now
    UpdateTags.update(
      tag_directory: options[:at] || DEFAULT_TAG_DIRECTORY,
      path_to_tag_index_page_template: options[:template] || DEFAULT_PATH_TO_TAG_INDEX_PAGE_TEMPLATE,
    )
  end
end

UpdateTagsCli.start(ARGV)
