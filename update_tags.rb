require "front_matter_parser"
require "fileutils"

def tag_index_page_source(tag)
  source = FrontMatterParser::Parser.parse_file("_includes/tag_index_page.md")
  front_matter = source.front_matter
  front_matter["tag"] = tag
  formatted_front_matter = front_matter.map do |key, value|
    "#{key}: #{value}"
  end.join("\n")
  <<~tag_index_page
    ---
    #{formatted_front_matter}
    ---

    #{source.content}
  tag_index_page
end

def url_tag(tag)
  tag.downcase.split(" ").join("-")
end

post_filenames = Dir.entries("./_posts") - [".", ".."]

tags = post_filenames.inject([]) do |tags, post_filename|
  tags += FrontMatterParser::Parser
    .parse_file("./_posts/#{post_filename}")
    .front_matter["tags"]
end.uniq

FileUtils.rm_rf('tag')
FileUtils.mkdir('tag')

tags.each do |tag|
  File.write(
    "tag/#{url_tag(tag)}.md",
    tag_index_page_source(tag),
  )
end
