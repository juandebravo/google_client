#!/usr/bin/env rake
require "bundler/gem_tasks"

Bundler::GemHelper.install_tasks

require 'rdoc/task'

task :default => [:spec]

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.skip_bundler = true
    spec.pattern = ['spec/*_spec.rb']
    spec.rspec_opts = '--color --format doc'
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.title = "google_client #{GoogleClient::VERSION} documentation"

  rdoc.rdoc_files.include('README.md')
  
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '-c' << 'utf-8'
  rdoc.options << '-m' << 'README.md'  
end

# extracted from https://github.com/grosser/project_template
desc "Bump version"
rule /^version:bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  puts index
  return
  file = 'lib/google_client/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add -f #{file} Gemfile.lock && git commit -m 'bump version to #{new_version}'"
end