
inname  =  "#{basename}#{extname}"

logger.debug "inname=#{inname}"
    
content = File.read_utf8( inname )


  gen_ctx = {
    extname: @extname,     ### todo/fix: check where is extname used??  why needed? try to remove!!!
  }


