require 'fileutils'

desc "run local server"
task :run do
  sh %{ foreman start }
end

if defined?(RSpec)
  require 'rspec/core/rake_task'
end
