module Slideshow
  module AnalyticsHelper
  
  
def google_analytics( opts = {} )

  # if no user account code (e.g. UA-397343-10) passed along use
  #   code from *.yml settings
  code = opts.fetch( :code, config.google_analytics_code ) 

  puts "  Adding JavaScript for Google Analytics tracker (#{code})..."

  text = <<EOS
<!-- begin google-analytics #{opts.inspect} -->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '#{code}']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
<!-- end google-analytics -->
EOS

  guard_block( text )             
end
  
  
end #   module AnalyticsHelper
end # module Slideshow


class Slideshow::Gen
  include Slideshow::AnalyticsHelper
end

