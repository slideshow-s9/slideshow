module Slideshow
  module MarkdownEngines

  def pandoc_ruby_to_html( content )
    content = PandocRuby.new( content, :from => :markdown, :to => :html ).convert
  end
  
  def pandoc_ruby_to_html_incremental( content )
    content = PandocRuby.new( content, :from => :markdown, :to => :html ).convert
    content = content.gsub(/<(ul|ol)/) do |match|
      "#{Regexp.last_match(0)} class='step'"
    end
    content
  end
  
  # sample how to use your own converter
  # configure in slideshow.yml
  # pandoc-ruby:
  #  converter: pandoc-ruby-to-s5
  
  def pandoc_ruby_to_s5( content )
    content = PandocRuby.new( content, {:from => :markdown, :to => :s5}, :smart ).convert
    content = content.gsub(/class="incremental"/,'class="step"')
    content = content.to_a[13..-1].join # remove the layout div
  end

  def pandoc_ruby_to_s5_incremental( content )
    content = PandocRuby.new( content, {:from => :markdown, :to => :s5 }, :incremental, :smart ).convert
    content = content.gsub(/class="incremental"/,'class="step"')
    content = content.to_a[13..-1].join # remove the layout div
  end
    
  def rdiscount_to_html( content )
    RDiscount.new( content ).to_html
  end
  
  def rpeg_markdown_to_html( content )
    PEGMarkdown.new( content ).to_html
  end
  
  def maruku_to_html( content )
    Maruku.new( content, {:on_error => :raise} ).to_html
  end
  
  def bluecloth_to_html( content )
    BlueCloth.new( content ).to_html
  end
  
  def kramdown_to_html( content )
    Kramdown::Document.new( content ).to_html
  end
  
  
  ### code for managing multiple markdown libs
  
  def load_markdown_libs
    # check for available markdown libs/gems
    # try to require each lib and remove any not installed
    @markdown_libs = []

    config.known_markdown_libs.each do |lib|
      begin
        require lib
        @markdown_libs << lib
      rescue LoadError => ex
        logger.debug "Markdown library #{lib} not found. Use gem install #{lib} to install."
      end
    end

    puts "  Found #{@markdown_libs.length} Markdown libraries: #{@markdown_libs.join(', ')}"
  end
 
  
  def markdown_to_html( content )
    # call markdown filter; turn markdown lib name into method_name (mn)
    # eg. rpeg-markdown =>  rpeg_markdown_to_html

    # lets you use differnt options/converters for a single markdown lib
    mn = config.markdown_to_html_method( @markdown_libs.first )    
    
    puts "  Converting Markdown-text (#{content.length} bytes) to HTML using library '#{@markdown_libs.first}' calling '#{mn}'..."
    
    send mn, content   # call 1st configured markdown engine e.g. kramdown_to_html( content )
  end
  
  
  

end   # module MarkdownEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MarkdownEngines
end