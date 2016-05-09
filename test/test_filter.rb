# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_filter.rb


require 'helper'


class TestFilter < MiniTest::Test

include Slideshow::DeckFilter

def test_slide_breaks_for_hr

  content =<<EOS

<p>some text</p>
<hr />
<p>some text</p>
<hr>
<p>some text</p>

EOS

  content_expected =<<EOS

<p>some text</p>

<!-- _S9SLIDE_ -->

<p>some text</p>

<!-- _S9SLIDE_ -->

<p>some text</p>

EOS


  assert_equal content_expected, add_slide_directive_for_hr( content )

end  # method test_slide_breaks_for_hr
  


end # class TestFilter

