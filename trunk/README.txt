= slideshow

Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby

* http://slideshow.rubyforge.org

== DESCRIPTION:

The Slide Show (S9) Ruby gem lets you create slide shows and author slides in plain text
using a wiki-style markup language that's easy-to-write and easy-to-read.
The Slide Show (S9) project also collects and welcomes themes and ships
"out-of-the-gem" with built-in support for "loss-free" gradient vector graphics themes.

== SYNOPSIS:

  Usage: slideshow [options] name
 
Examples:

  slideshow microformats
  slideshow microformats.textile
  slideshow -s5 microformats       # S5 compatible
  slideshow -f microformats        # FullerScreen compatible
  slideshow -o slides microformats # Output slideshow to slides folder

More examles:

  slideshow -g      # Generate slide show templates
  slideshow -g -s5  # Generate S5 compatible slide show templates
  slideshow -g -f   # Generate FullerScreen compatible slide show templates

  slideshow -t s3.txt microformats     # Use custom slide show templates

== REQUIREMENTS:

* RedCloth (Textile Markup)
* BlueCloth (Markdown Markup)

* RDiscount (Markdown Markup) [Optional]
* Coderay (Syntax Highlighting) [Optional]
* Ultraviolet (Syntax Highlighting) [Optional]

== INSTALL:

Just install the gem:

  $ sudo gem install slideshow

== LICENSE:

The slide show scripts and templates are dedicated to the public domain. Use it as you please with no restrictions whatsoever.