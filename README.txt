ActsAsRunnableCode
    by David Stevenson
    http://elctech.com/blog

== DESCRIPTION:
  
ActsAsRunnable attempts to make the Freaky Freaky Sandbox easier to use.  It assumes that you have a class that has instances that store user uploaded code in them.  It also assumes that you want use your classes in the sandbox with reduced "safe" functionality provided by acts_as_wrapped_class.  Finally, it assumes that you want to evaluate an instance of user uploaded code within the context of some instance of a wrapped class.

See the example app using this gem: http://tictactoe.mapleton.net

== FEATURES/PROBLEMS:
  
* Run user uploaded code in the sandbox
* Automatic use of wrapper classes inside the sandbox, and unwrapping return results

== SYNOPSIS:

require "sandbox"
require "acts_as_runnable_code"

class Algorithm < ActiveRecord::Base
  # "code" is a database attribute in this case, containing user's code
  acts_as_runnable_code :classes => ["Board"]
end

class Board < ActiveRecord::Base
  belongs_to :algorithm
  acts_as_wrapped_class, :methods => [:moves, :make_move!, :turn, :log_info, :log_debug]
  def moves; end
  def make_move!(x,y); end;
  ...
end

# Runs a user uploaded alogrithm in the context of a board
board = Board.find(id)
board.algorithm.run_code(board, :timeout => 0.5)

== REQUIREMENTS:

* acts_as_wrapped_class (gem)
* sandbox (gem)

== INSTALL:

* sudo gem install acts_as_wrapped_class
* download and install sandbox: http://code.whytheluckystiff.net/sandbox/
* sudo gem install acts_as_runnable_code

== LICENSE:

(The MIT License)

Copyright (c) 2007 David Stevenson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
