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

    # Change to .md extension by moving .html file
    FileUtils.mv("content/#{page}.html", "content/#{page}.md")
    $stdout.puts "\tMoved content/#{page}.html to content/#{page}.markdown"
  end

end
