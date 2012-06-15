module Slideshow

class List

  include Manifest   # gets us methods like installed_template_manifests, etc.

### fix: remove opts, use config (wrapped!!)
  
  def initialize( logger, opts, config, headers )
    @logger  = logger
    @opts    = opts
    @config  = config
    @headers = headers
  end

  attr_reader :logger, :opts, :config, :headers


  def list_slideshow_templates
    manifests = installed_template_manifests
    
    puts ''
    puts 'Installed templates include:'
    
    manifests.each do |manifest|
      puts "  #{manifest[0]} (#{manifest[1]})"
    end
  end


end # class List

end # class Slideshow