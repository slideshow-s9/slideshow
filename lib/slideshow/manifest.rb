module Slideshow
  module Manifest
  
  def load_manifest_core( path )
    manifest = []
  
    File.open( path ).readlines.each_with_index do |line,i|
      case line
      when /^\s*$/
        # skip empty lines
      when /^\s*#.*$/
        # skip comment lines
      else
        logger.debug "line #{i+1}: #{line.strip}"
        values = line.strip.split( /[ <,+]+/ )
        
        # add source for shortcuts (assumes relative path; if not issue warning/error)
        values << values[0] if values.size == 1
                
        manifest << values
      end      
    end

    manifest
  end

  def load_manifest( path )
        
    filename = path
 
    puts "  Loading template manifest #{filename}..."  
    manifest = load_manifest_core( filename )
    
    # post-processing
    # normalize all source paths (1..-1) /make full path/add template dir

    templatesdir = File.dirname( path )
    logger.debug "templatesdir=#{templatesdir}"

    manifest.each do |values|
      (1..values.size-1).each do |i|
        values[i] = "#{templatesdir}/#{values[i]}"
        logger.debug "  path[#{i}]=>#{values[i]}<"
      end
    end
             
    manifest
  end

  def find_manifests( patterns )
    manifests = []
    
    patterns.each do |pattern|
      pattern.gsub!( '\\', '/')  # normalize path; make sure all path use / only
      logger.debug "Checking #{pattern}"
      Dir.glob( pattern ) do |file|
        logger.debug "  Found manifest: #{file}"
        manifests << [ File.basename( file ), file ]
      end    
    end
    
    manifests
  end
  
  def installed_generator_manifests
    # 1) search gem/templates 

    builtin_patterns = [
      "#{File.dirname( LIB_PATH )}/templates/*.txt.gen"
    ]

    find_manifests( builtin_patterns )
  end

  def installed_template_manifests
    # 1) search ./templates
    # 2) search config_dir/templates
    # 3) search gem/templates

    builtin_patterns = [
      "#{File.dirname( LIB_PATH )}/templates/*.txt"
    ]
    config_patterns  = [
      "#{config_dir}/templates/*.txt",
      "#{config_dir}/templates/*/*.txt"
    ]
    current_patterns = [
      "templates/*.txt",
      "templates/*/*.txt"
    ]
    
    patterns = []
    patterns += current_patterns  unless LIB_PATH == File.expand_path( 'lib' )  # don't include working dir if we test code from repo (don't include slideshow/templates)
    patterns += config_patterns
    patterns += builtin_patterns
 
    find_manifests( patterns )
  end
    
  end # module  Manifest
end # module Slideshow

class Slideshow::Gen
  include Slideshow::Manifest
end