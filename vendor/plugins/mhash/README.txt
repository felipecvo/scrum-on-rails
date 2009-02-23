= Mhash (Mocking Hash)

http://github.com/mbleigh/mhash

== DESCRIPTION:

Mhash is an extended Hash that gives simple pseudo-object functionality
that can be built from hashes and easily extended. It is designed to
be used in RESTful API libraries to provide easy object-like access 
to JSON and XML parsed hashes.

== SYNOPSIS:
  
  mhash = Mhash.new
  mhash.name? # => false
  mhash.name # => nil
  mhash.name = "My Mhash"
  mhash.name # => "My Mhash"
  mhash.name? # => true
  mhash.inspect # => <Mhash name="My Mhash">
  
  mhash = Mhash.new
  # use bang methods for multi-level assignment
  mhash.author!.name = "Michael Bleigh"
  mhash.author # => <Mhash name="Michael Bleigh">

== INSTALL:

Gem:

Mhash is hosted on the GitHub gem repository, so if you haven't already:

  gem sources -a http://gems.github.com/  
  sudo gem install mbleigh-mhash
  
Git:

  git clone git://github.com/mbleigh/mhash.git
  
== RESOURCES

If you encounter any problems or have ideas for new features 
please report them at the Lighthouse project for Mhash: 

http://mbleigh.lighthouseapp.com/projects/10112-mash

== LICENSE:

Copyright (c) 2008 Michael Bleigh (http://mbleigh.com/) 
and Intridea Inc. (http://intridea.com/), released under the MIT license

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
