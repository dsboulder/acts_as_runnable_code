# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/acts_as_runnable_code.rb'

Hoe.new('acts_as_runnable_code', ActsAsRunnableCode::VERSION) do |p|
  p.rubyforge_name = 'acts_as_runnable_code'
  p.author = 'David Stevenson'
  p.email = 'ds@elctech.com'
  p.summary = 'Mark a class as containing a method which returns sandbox runnable code.  Helps by building the sandbox and setting up the eval for you.'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.rubyforge_name = "runnable-code"
  p.remote_rdoc_dir = ""
  p.rsync_args << ' --exclude=statsvn/'
  p.extra_deps << ['acts_as_wrapped_class', '>= 1.0.1']
end

# vim: syntax=Ruby
