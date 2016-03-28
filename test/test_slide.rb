# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_slide.rb


require 'helper'


class TestSlide < MiniTest::Test

def test_slide1
  
  opts = Slideshow::Opts.new
  
  content =<<EOS
<h1 id="test-header-1">test header 1</h1>

<p>test content 1</p>
EOS
  
  slide = Slideshow::Slide.new( content, opts )
  
  puts "header:"
  pp slide.header
  puts "content:"
  pp slide.content
  puts "content_without_header:"
  pp slide.content_without_header
  puts "classes:"
  pp slide.classes
  puts "data_attributes:"
  pp slide.data_attributes
  
  assert_equal %Q{<h1 id="test-header-1">test header 1</h1>}, slide.header
  assert_equal content, slide.content
  assert_equal nil, slide.classes
  assert_equal nil, slide.data_attributes
  
end  # method test_slide


end # class TestSlide

