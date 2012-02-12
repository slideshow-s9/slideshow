require 'redcloth'  ## todo: move into setup method???

##
## see https://github.com/mojombo/jekyll/wiki/Plugins
## for info about Jekyll plugins (such as your own markup converter)

module Jekyll
  class TextilePlusConverter < Converter
    safe true    # todo: what does it mean??

    priority :low    ## todo: check if priority is ok?

    def matches(ext)
      ext =~ /(text)|(txt)/i
    end 

    def output_ext(ext)
      ".html"
    end

    def convert(content)
  puts "[debug] calling markup converter 'textileplus'"
  
  red = RedCloth.new( content, [:no_span_caps] )
  red.hard_breaks = false
  content = red.to_html
  
  # html4.01/html5 strict mode 
  # change /> to just >
  #  textile/RedCloth creates <img /> etc. not sure if there's a html output flag/switch
  content.gsub!( "/>", ">" )
  content
    end
  end
end