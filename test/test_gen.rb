# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_gen.rb


require 'helper'


class TestGen < MiniTest::Test

def test_gen_test

   opts    = Slideshow::Opts.new
   
   opts.test         = true     # (auto-)includes templates from /test/templates
   opts.verbose      = true     # turn on (verbose) debug output
   opts.manifest     = 'test'
   opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   g = Slideshow::Gen.new( config )
   g.create_slideshow( "#{Slideshow.root}/test/samples/test.md" )
  
  assert true
end  # method test_gen

end # class TestGen

