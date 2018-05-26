$LOAD_PATH.unshift('./lib')

require 'bundler/setup'
Bundler.require

desc "check today lab cleaner"
task :check_cleaner do
  require 'lab-cleaner-checker'
  check_lab_cleaner()
end

namespace :web do
  desc "exec web server"
  task :run do
    require 'web'
    run_web()
  end
end
