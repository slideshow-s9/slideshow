# encoding: utf-8

module Slideshow


## note: just extents version in slideshow-models


class Opts

  def merge_gli_options!( options={} )
    @header_level = 1   if options[:h1] == true
    @header_level = 2   if options[:h2] == true
    
    @slide     = true   if options[:slide] == true
    @takahashi = true   if options[:slide] == true
    
    @verbose = true     if options[:verbose] == true
    
    @fetch_all = true   if options[:all] == true
    
    @config_path = options[:config]    if options[:config].present?
    @output_path = options[:output]    if options[:output].present?
    
    @manifest       =   options[:template]  if options[:template].present?
    
    ## NB: will use :template option too
    @quick_manifest =   options[:template]  if options[:template].present?
  end

end # class Opts

end # module Slideshow

