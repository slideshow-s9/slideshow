# encoding: utf-8

module Slideshow

class ManifestFinder

  include LogUtils::Logging

  include ManifestHelper


  def initialize( config )
    @config = config
    @usrdir = File.expand_path( Dir.pwd )  # save original (current) working directory
  end

  attr_reader :config
  attr_reader :usrdir   # original working dir (user called slideshow from)


  def find_manifestsrc( manifest_arg )    ## rename - just use find_manifest ??

    manifest_path_or_name = manifest_arg.dup   ## make a copy

    # add .txt file extension if missing (for convenience)
    if manifest_path_or_name.downcase.ends_with?( '.txt' ) == false
      manifest_path_or_name << '.txt'
    end

    logger.debug "manifest=#{manifest_path_or_name}"

    # check if file exists (if yes use custom template package!) - allows you to override builtin package with same name
    if File.exists?( manifest_path_or_name )
      manifestsrc = manifest_path_or_name
    else
      # check for builtin manifests
      manifests = installed_template_manifests
      matches = manifests.select { |m| m[0] == manifest_path_or_name }

      if matches.empty?
        puts "*** error: unknown template manifest '#{manifest_path_or_name}'"
        puts
        puts "Use"
        puts "  slideshow list      # or"
        puts "  slideshow ls"
        puts "to see what template packs you have installed."
        puts
        puts "Use"
        puts "  slideshow install #{manifest_path_or_name.sub('.txt','')}      # or"
        puts "  slideshow i #{manifest_path_or_name.sub('.txt','')}"
        puts "to (try to) install the missing template pack."
        puts
        puts "See github.com/slideshow-templates for some ready-to-use/download template packs"
        puts "or use your very own."
        puts

        # todo: list installed manifests - why? why not?
        exit 2
      end

      manifestsrc = matches[0][1]
    end

    ### todo: use File.expand_path( xx, relative_to ) always with second arg
    ##   do NOT default to cwd (because cwd will change!)

    # Reference src with absolute path, because this can be used with different pwd
    manifestsrc = File.expand_path( manifestsrc, usrdir )
    manifestsrc
  end


end # class ManifestFinder

end # class Slideshow
