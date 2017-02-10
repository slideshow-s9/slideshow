# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_build.rb


require 'helper'


class TestBuild < MiniTest::Test

def test_build_test

   opts    = Slideshow::Opts.new
   
   opts.test         = true     # (auto-)includes templates from /test/templates
   opts.verbose      = true     # turn on (verbose) debug output
   opts.manifest     = 'test'
   opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   g = Slideshow::Build.new( config )
   g.create_slideshow( "#{Slideshow.root}/test/samples/test.md" )
  
  assert true
end  # method test_build


def test_build_test_content_for

   opts    = Slideshow::Opts.new
   
   opts.test         = true     # (auto-)includes templates from /test/templates
   opts.verbose      = true     # turn on (verbose) debug output
   opts.manifest     = 'test'
   opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   g = Slideshow::Build.new( config )
   g.create_slideshow( "#{Slideshow.root}/test/samples/test_content_for.md" )
  
  assert true
end  # method test_build


end # class TestBuild

