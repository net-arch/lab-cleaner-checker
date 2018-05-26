$LOAD_PATH.unshift('./lib')

require 'bundler/setup'
Bundler.require

require 'lab-cleaner-checker'

check_lab_cleaner()
