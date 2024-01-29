require 'fileutils'
require 'time'

include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering

def title
  if @item[:title]
    "#{@item[:title]} | Ming-Ho Yee"
  else
    "Ming-Ho Yee"
  end
end

def pretty_time(time)
  Time.parse(time.to_s).strftime("%B %-d, %Y") if !time.nil?
end
