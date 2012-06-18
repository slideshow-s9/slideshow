# Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby

* [`slideshow.rubyforge.org`](http://slideshow.rubyforge.org)

## DESCRIPTION

The Slide Show (S9) Ruby gem lets you create slide shows and author slides in plain text
using a wiki-style markup language that's easy-to-write and easy-to-read.
The Slide Show (S9) project also collects and welcomes themes and ships
"out-of-the-gem" with built-in support for "loss-free" gradient vector graphics themes.

## SYNOPSIS

    Slide Show (S9) is a free web alternative to PowerPoint or KeyNote in Ruby
    
    Usage: slideshow [options] name
      -o, --output PATH                Output Path (default is .)
      -t, --template MANIFEST          Template Manifest (default is s6.txt)
          --h1                         Set Header Level to 1 (default)
          --h2                         Set Header Level to 2
      -f, --fetch URI                  Fetch Templates
      -l, --list                       List Installed Templates
      -c, --config PATH                Configuration Path (default is ~/.slideshow)
      -g, --generate                   Generate Slide Show Templates (using built-in S6 Pack)
      -q, --quick                      Generate Quickstart Slide Show Sample
      -v, --version                    Show version
          --verbose                    Show debug trace
      -h, --help                       Show this message

    Examples:
      slideshow microformats
      slideshow microformats.text            # Process slides using Markdown
      slideshow microformats.textile         # Process slides using Textile
      slideshow microformats.rst             # Process slides using reStructuredText
      slideshow -o slides microformats       # Output slideshow to slides folder
    
    More examles:
      slideshow -q                           # Generate quickstart slide show sample
      slideshow -g                           # Generate slide show templates using built-in S6 pack
      
      slideshow -l                           # List installed slide show templates
      slideshow -f s5blank                   # Fetch (install) S5 blank starter template from internet
      slideshow -t s5blank microformats      # Use your own slide show templates (e.g. s5blank)


## INSTALL

Just install the gem:

    $ gem install slideshow

## QUESTION? COMMENTS?

Send them along to the [Free Web Slide Show Alternatives (S5, S6, S9, Slidy And Friends) Forum/Mailing List](http://groups.google.com/group/webslideshow).
Thanks!

## LICENSE

The `slideshow` scripts and templates are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.