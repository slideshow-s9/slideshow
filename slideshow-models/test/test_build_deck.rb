# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_build_deck.rb


require 'helper'


class TestBuildDeck < MiniTest::Test


def test_build_test

   opts    = Slideshow::Opts.new
   
   opts.verbose      = true     # turn on (verbose) debug output
   opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   b = Slideshow::Build.new( config )
   buf  = File.read_utf8( "#{Slideshow.root}/test/samples/test.md" )
   deck = b.create_deck_from_string( buf )
  
   pp deck
  
  assert true
end  # method test_build


def test_build_test_content_for

   opts    = Slideshow::Opts.new
   
   opts.verbose      = true     # turn on (verbose) debug output
   opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   b = Slideshow::Build.new( config )
   buf  = File.read_utf8( "#{Slideshow.root}/test/samples/test_content_for.md" )
   deck = b.create_deck_from_string( buf )

   pp deck
  
   assert true
end  # method test_build


end # class TestBuildDeck

