require "thor"
require_relative "./update_tags"

# update_tags --at tag --watch

class UpdateTagsCli < Thor
  option :at
  desc "now", "update your jekyll blog's tag index pages"
  def now
    UpdateTags.update({ tag_directory: options[:at] || "tag" })
  end
end

UpdateTagsCli.start(ARGV)
