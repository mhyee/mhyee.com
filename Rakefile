begin
  require 'nanoc3/tasks'
  require 'fileutils'
rescue LoadError
  require 'rubygems'
  require 'nanoc3/tasks'
  require 'fileutils'
end

task :default => [:compile]

desc "Default task, compiles site"
task :compile do
  sh 'nanoc compile'

  # Open the diff file in MacVim, if it exists
  sh 'mvim output.diff' if File.exists?('output.diff')
end

namespace :create do

  desc "Creates a new page"
  task :page => [:item]
  task :item do
    # Run through nanoc ci to create item
    if !(title = ENV['title'])
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title'"
      exit 1
    end
    sh "nanoc create_item #{title}"

    # Change to .markdown extension by moving .html file
    FileUtils.mv("content/#{title}.html", "content/#{title}.markdown")
    $stdout.puts "\tMoved content/#{title}.html to content/#{title}.markdown"
  end

  # Adapted from https://github.com/mgutz/nanoc3_blog/blob/master/Rakefile
  desc "Creates a new article (blog post)"
  task :post => [:article]
  task :article do
    require 'active_support/core_ext'
    @ymd = Time.now.to_s.split(' ')[0]
    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title'"
      exit 1
    end

    title = ENV['title'].capitalize
    path, filename, full_path = calc_path(title)

    if File.exists?(full_path)
      $stderr.puts "\t[error] Exists #{full_path}"
      exit 1
    end

    template = <<TEMPLATE
---
created_at: #{@ymd}
foo: _bar
excerpt:
kind: article
tags: [misc]
title: "#{title.titleize}"
---

TODO: Add content to `#{full_path}.`
TEMPLATE

    FileUtils.mkdir_p(path) if !File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  def calc_path(title)
    path = "content/blog/"
    filename = title.parameterize('_') + ".markdown"
    [path, filename, path + filename]
  end

end
