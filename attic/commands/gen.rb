
###
## code from class Gen

attr_reader :markup_type  # :textile, :markdown, :mediawiki, :rest

  # uses configured markup processor (textile,markdown,rest,mediawiki) to generate html
  def text_to_html( content )
    content = case @markup_type
      when :markdown
        markdown_to_html( content )
      when :textile
        textile_to_html( content )
      when :mediawiki
        mediawiki_to_html( content )
      when :rest
        rest_to_html( content )
    end
    content
  end

  def guard_text( text )
    # todo/fix 2: note for Textile we need to differentiate between blocks and inline
    #   thus, to avoid runs - use guard_block (add a leading newline to avoid getting include in block that goes before)
    
    # todo/fix: remove wrap_markup; replace w/ guard_text
    #   why: text might be css, js, not just html
    
    ## todo: add print depreciation warning
    
    wrap_markup( text )
  end

  def guard_block( text )
    if markup_type == :textile
      # saveguard with notextile wrapper etc./no further processing needed
      # note: add leading newlines to avoid block-runons
      "\n\n<notextile>\n#{text}\n</notextile>\n"
    elsif markup_type == :markdown
      # wrap in newlines to avoid runons
      "\n\n#{text}\n\n"
    elsif markup_type == :mediawiki
      "\n\n<nowiki>\n#{text}\n</nowiki>\n"
    else
      text
    end
  end


  def wrap_markup( text )
    if markup_type == :textile
      # saveguard with notextile wrapper etc./no further processing needed
      "<notextile>\n#{text}\n</notextile>"
    else
      text
    end
  end

  # move into a filter??
  def post_processing_slides( content )
    
    # 1) add slide breaks
  
    if config.slide?  # only allow !SLIDE directives fo slide breaks?
       # do nothing (no extra automagic slide breaks wanted)
    else  
      if (@markup_type == :markdown && Markdown.lib == 'pandoc-ruby') || @markup_type == :rest
        content = add_slide_directive_before_div_h1( content )
      else
        if config.header_level == 2
          content = add_slide_directive_before_h2( content )
        else # assume level 1
          content = add_slide_directive_before_h1( content )
        end
      end
    end
  end

  def create_slideshow( fn )

  if config.known_textile_extnames.include?( extname )
    @markup_type = :textile
  elsif config.known_rest_extnames.include?( extname )
    @markup_type = :rest
  elsif config.known_mediawiki_extnames.include?( extname )
    @markup_type = :mediawiki
  else  # default/fallback use markdown
    @markup_type = :markdown
  end

   #....
   
  if @markup_type == :markdown && config.markdown_post_processing?( Markdown.lib ) == false
    puts "  Skipping post-processing (passing content through as is)..."
    @content = content  # content all-in-one - make it available in erb templates
  else
    # sets @content (all-in-one string) and @slides (structured content; split into slides)
    post_processing_slides( content )
  end
   

  end



