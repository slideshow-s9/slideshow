
##
#  slideshow microformats.textile         # Process slides using Textile (#{config.known_textile_extnames.join(', ')})
#  slideshow microformats.rst             # Process slides using reStructuredText (#{config.known_rest_extnames.join(', ')})
#  slideshow microformats.text            # Process slides using Markdown (#{config.known_markdown_extnames.join(', ')})
#


    finder = FileFinder.new( config )

    args.each do |arg|
      files = finder.find_files( arg )
      files.each do |file|
        Slideshow::Gen.new( config ).create_slideshow( file )
      end
    end


  if opts.verbose?
    # dump Markdown settings
    Markdown.dump
    puts
  end


##
##  note: no longer provide update command -
#    -- index/registry doesn't really change so often for now (keep it "static/simple" for now)


desc "Update shortcut index for template packs 'n' plugins"
command [:update,:u] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from update command'

    Slideshow::Update.new( config ).update
  end
end
