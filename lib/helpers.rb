require 'fileutils'
require 'time'

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering

def title
  if @item[:title]
    "#{@item[:title]} · Ming-Ho Yee"
  else
    "Ming-Ho Yee"
  end
end

def pretty_time(time)
  Time.parse(time.to_s).strftime("%B %-d, %Y") if !time.nil?
end

def format_author(author)
  if author == "Ming-Ho Yee"
    '<strong>Ming-Ho Yee</strong>'
  else
    author
  end
end

def wrap(text, indent=0)
  spaces = " " * indent

  # The regex matches up to 74 characters, then a comma, before inserting
  # a linebreak, followed by indentation.
  text
    .gsub(/(.{1,74})(,|$)/, "\\1\\2\n #{spaces}") # insert a linebreak after 74 columns
    .strip                                        # remove extra whitespace
end

def print_authors(authors)
  list = authors.map{|a| format_author a }.join(", ")
  wrap list, 4
end
