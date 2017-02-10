# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_kramdown.rb


require 'helper'


class TestKramdown < MiniTest::Test

def test_to_html
  
  config = {
    'input'     => 'GFM',
    'hard_wrap' => false
  }
  
  content =<<EOS
# Heading 1

some text with `code` and some more text
and some more text

```
a code block
```

some more text
EOS
  
  html = Kramdown::Document.new(content, config).to_html
  pp html
  assert true
end  # method test_to_html


def test_rouge
  
  config = {
    'input'     => 'GFM',
    'hard_wrap' => false,
    'syntax_highlighter' => 'rouge'
  }
  
  content =<<EOS
# Heading 1

some text with `code` and some more text
and some more text

```ruby
puts 'Hello, World!'
```

some more text
EOS
  
  html = Kramdown::Document.new(content, config).to_html
  pp html
  assert true
end  # method test_rouge


end # class TestKramdown

