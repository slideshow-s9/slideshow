# Todos

## move templated merged out of gen command


## multiple files get (auto-)merged

allow many files as inputs
will only generate/build ONE slideshow

-> no longer possible to pass in many slide shows at once (has anyone ever used this option?)

add -n/--name option for setting @name for output generation


## allow css and js etc.

allow css and js input files
get (auto-add) to

- content_for :css
- content_for :js
- etc.

also add extra_css/css header for easy adding extra css in config or header etc.

same for js ;-)


## improved slide header spliting

- allow heading 1 AND heading 2

- use heading 1 for sections
- use heading 2 for slides

- add/allow --- for slide separator


## docu

move all references about textile to attic
(textile no longer supported in core - out-of-the-box - sorry)


## add support for latex/beamer

use kramdown (markdown) for latex conversion



## syntax highligher

update/use rouge; move coderay and ??  to deprecated (and/or attic)

