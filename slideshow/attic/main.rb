
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
