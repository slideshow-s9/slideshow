# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'


class TestVersion < MiniTest::Test

def test_version
  
  puts "version:"
  puts Slideshow.version
  puts "root:"
  puts Slideshow.root
  puts "generator:"
  puts Slideshow.generator
  puts "banner:"
  puts Slideshow.banner
  
  assert true
end  # method test_version


end # class TestVersion

