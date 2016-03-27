# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'


class TestVersion < MiniTest::Test

def test_version
  
  puts Slideshow.version
  puts Slideshow.root
  puts Slideshow.generator
  puts Slideshow.banner
  
  assert true
end  # method test_version


end # class TestVersion

