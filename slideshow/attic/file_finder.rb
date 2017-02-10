
class FileFinder
  include LogUtils::Logging

  def initialize( config )
    @config = config
  end
  
  attr_reader :config

  def find_file_with_known_extension( fn )
    dirname  = File.dirname( fn )
    basename = File.basename( fn, '.*' )
    extname  = File.extname( fn )
    logger.debug "dirname=#{dirname}, basename=#{basename}, extname=#{extname}"

    config.known_extnames.each do |e|
      newname = File.join( dirname, "#{basename}#{e}" )
      logger.debug "File.exists? #{newname}"
      return newname if File.exists?( newname )
    end  # each extension (e)
      
    nil   # not found; return nil
  end


  def find_files( file_or_dir_or_pattern )
    filtered_files = []
 
    ## for now process/assume only single file
    
    ## (check for missing extension)
    if File.exists?( file_or_dir_or_pattern )
      file = file_or_dir_or_pattern
      logger.debug "  adding file '#{file}'..."
      filtered_files << file
    else  # check for existing file w/ missing extension
      file = find_file_with_known_extension( file_or_dir_or_pattern )
      if file.nil?
        puts "  skipping missing file '#{file_or_dir_or_pattern}{#{config.known_extnames.join(',')}}'..."
      else
        logger.debug "  adding file '#{file}'..."
        filtered_files << file
      end
    end
    
    filtered_files 
  end # method find_files
end # class FileFinder

