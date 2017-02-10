# slideshow gem - slide show (S9) command line tool -  a free web alternative to PowerPoint and Keynote in ruby

* docu      :: [slideshow-s9.github.io](http://slideshow-s9.github.io)
* source    :: [github.com/slideshow-s9/slideshow](https://github.com/slideshow-s9/slideshow)
* bugs      :: [github.com/slideshow-s9/slideshow/issues](https://github.com/slideshow-s9/slideshow/issues)
* gem       :: [rubygems.org/gems/slideshow](https://rubygems.org/gems/slideshow)
* rdoc      :: [rubydoc.info/gems/slideshow](http://rubydoc.info/gems/slideshow)
* templates :: [github.com/slideshow-templates](https://github.com/slideshow-templates)
* forum     :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)


## Description

The Slide Show (S9) Ruby gem lets you create slide shows and author slides in plain text
using a wiki-style markup language that's easy-to-write and easy-to-read.
The Slide Show (S9) project also collects and welcomes themes and ships
"out-of-the-gem" with built-in support for "loss-free" gradient vector graphics themes.

```
SYNOPSIS
    slideshow [global options] command [command options] [arguments...]

VERSION
    3.0.0

GLOBAL OPTIONS
    -c, --config=PATH - Configuration Path (default: ~/.slideshow)
    --verbose         - (Debug) Show debug messages
    --version         - Show version

COMMANDS
    build, b           - Build slideshow
    install, i         - Install template pack
    list, ls, l        - List installed template packs
    new, n             - Generate quick starter sample
    about, a           - (Debug) Show more version info
    help               - Shows a list of commands or help for one command
```


### `build` Command

```
NAME
    build - Build slideshow

SYNOPSIS
    slideshow [global options] build [command options] FILE

COMMAND OPTIONS
    --h1                    - Set Header Level to 1 (default)
    --h2                    - Set Header Level to 2
    --takahashi             - Allow // for slide breaks
    --slide                 - Use only !SLIDE for slide breaks (Showoff Compatible)
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: s6)

EXAMPLES
    slideshow build microformats.text
    slideshow build microformats.text -o slides       # Output slideshow to slides folder
    slideshow build microformats.text -t s5blank      # Use your own slide show templates (e.g. s5blank)
```


### `list` Command

```
NAME
    list - List installed template packs

SYNOPSIS
    slideshow [global options] list [command options]

EXAMPLES
    slideshow list
    slideshow ls
```


### `install` Command

```
NAME
    install - Install template pack

SYNOPSIS
    slideshow [global options] install [command options] MANIFEST

COMMAND OPTIONS
    -a, --all - Template Packs (s5blank, s5themes, slidy, g5, csss, deck.js, impress.js)

EXAMPLES
    slideshow install impress.js
    slideshow install https://raw.github.com/.../impress.js.txt
```


### `new` Command

```
NAME
    new - Generate quick starter sample

SYNOPSIS
    slideshow [global options] new [command options]

COMMAND OPTIONS
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: welcome)

EXAMPLES
    slideshow new
    slideshow new -t impress.js
```


## Install

Just install the gem:

    $ gem install slideshow

## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `slideshow` scripts and templates are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake forum/mailing list](http://groups.google.com/group/wwwmake).
Thanks!
