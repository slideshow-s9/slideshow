# encoding: utf-8

module Slideshow
  module MediawikiEngines


  def setup_mediawiki_engine
    return if @mediawiki_engine_setup
    logger.debug 'require wikicloth  -- load mediawiki library'
    require 'wikicloth'          # default mediawiki library
    @mediawiki_engine_setup = true
  rescue LoadError
    puts "You're missing a library required for Mediawiki to Hypertext conversion. Please run:"
    puts "   $ gem install wikicloth"
    #  check: raise exception instead of exit e.g
    #  raise FatalException.new( 'Missing library dependency: wikicloth' )
    exit 1
  end


  def mediawiki_to_html( content )
    
    setup_mediawiki_engine()
    
    puts "  Converting Mediawiki-text (#{content.length} bytes) to HTML..."

    # NB: turn off table_of_contents (TOC) auto-generation with __NOTOC__
    # NB: turn off adding of edit section/markers for headings (noedit:true)

    wiki = WikiCloth::Parser.new( data: "__NOTOC__\n"+content, params: {} )

    content = wiki.to_html( noedit: true )
  end

  end  # module MediawikiEngines
end # module Slideshow

class Slideshow::Gen
  include Slideshow::MediawikiEngines
end
