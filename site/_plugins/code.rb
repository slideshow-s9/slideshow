module Jekyll

# Usage
#
# {% code %}
#  -- Your code goes here...
# {% endcode %}


    class CodeBlock < Liquid::Block

        def initialize(tag_name, lang, tokens)
          super
        end

        def render(context)
          puts "[debug] calling liquid block tag 'code'"
          code = super
          "<pre class='programlisting'>#{code}</pre>"
        end
    end

end

Liquid::Template.register_tag('code', Jekyll::CodeBlock)