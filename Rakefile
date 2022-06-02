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

  # Open the diff file in vim, if it exists
  sh 'vimdiff output.diff' if File.exists?('output.diff')
end

namespace :create do

  desc "Creates a new page"
  task :page => [:item]
  task :item do
    # Run through nanoc ci to create item
    if !(page = ENV['page'])
      $stderr.puts "\t[error] Missing page argument.\n\tusage: rake create:article page='page slug'"
      exit 1
    end
    sh "nanoc create_item #{page}"

    # Change to .markdown extension by moving .html file
    FileUtils.mv("content/#{page}.html", "content/#{page}.markdown")
    $stdout.puts "\tMoved content/#{page}.html to content/#{page}.markdown"
  end

  # Adapted from https://github.com/mgutz/nanoc3_blog/blob/master/Rakefile
  desc "Creates a new article (blog post)"
  task :post => [:article]
  task :article do
    require 'active_support/core_ext'
    @ymd = Time.now.to_s.split(' ')[0]
    if !ENV['slug']
      $stderr.puts "\t[error] Missing slug argument.\n\tusage: rake create:article slug='slug'"
      exit 1
    end

    slug = ENV['slug'].capitalize
    path, filename, full_path = calc_path(slug)

    if File.exists?(full_path)
      $stderr.puts "\t[error] Exists #{full_path}"
      exit 1
    end

    template = <<TEMPLATE
---
created_at: #{@ymd}
excerpt: "An article about #{slug}"
kind: article
tags: [ misc ]
title: "Title for #{slug}"
publish: false
---

TODO: Add content to `#{full_path}.`
TEMPLATE

    FileUtils.mkdir_p(path) if !File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  def calc_path(title)
    path = "content/blog/"
    filename = title.parameterize('_') + ".md"
    [path, filename, path + filename]
  end

end
