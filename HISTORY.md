=== 0.9.8 / 2011-02-06

* Added support for HTTPS and HTTP redirect for downloads
* Update builtin S6 blank template

=== 0.9.7 / 2010-07-22

* Added support for reStructedText (using pandoc-ruby gem)
* Update builtin S6 blank templates (toggle slide counter, debug, etc.)
* Update SyntaxHighlighter helper

=== 0.9.6 / 2010-07-18

* Update builtin S6 blank templates (adding autoplay, custom transitions, custom title selector, and more)

=== 0.9.5 / 2010-07-14

* Minor fix (for custom converter methods)

=== 0.9.4 / 2010-07-14

* Added support for custom converter methods (for Markdown processing)

=== 0.9.3 / 2010-07-13

* Added support for pandoc-ruby (for Markdown processing); skip %-filters; break slides using div/h1 rule [Thanks David Sanson]

=== 0.9.2 / 2010-07-11

* Change default template pack from s6gradients to s6blank
* Added syntax highlighting helper (sh) for SyntaxHighlighter JavaScript Library
* Added gradient and background helper
* Added simplified parameters for Django-style expressions and statements
* Added support for %-directives (e.g. %helper, %css, %yourown, etc)
* Minor fixes 

=== 0.9  / 2010-07-04

* Added support for !SLIDE (and alternative syntax %slide)
* Added support for comments using %, %begin/%end and %end
* Added more helpers (step, google_analytics, left/right for two-column layouts)
* Added support for Django-style expressions and statements as an alternative to <% %>
* Added support for configuring text filters in slideshow.yml
* Added support for configuring Markdown engines in slideshow.yml
* Added fetch shortcuts (configure in slideshow.yml)
* Added support for template manifests w/o .txt extensions 
* Removed old options -s5,--fullerscreen (use -t s5blank or -t fullerscreen instead) 

=== 0.8.5  / 2010-06-25

* Added workaround for RedCloth 4 (Java-only) multi-byte character bug 

=== 0.8.4  / 2010-06-24

* Added support for proxy via HTTP_PROXY env for fetching templates from the internet

=== 0.8.3  / 2010-06-23

* Added support for @slides and @content variables in templates

=== 0.8.2  / 2010-06-19

* Add pdf templates to built-in S6 template package
* Started to add hash support to S6 script  

=== 0.8.1 / 2010-06-13

* Add patches for Ruby 1.9 compatibility [Thanks Lorenzo Riccucci]
* Replaced BlueCloth 1.x with Kramdown 0.8 as default markdown engine
* Minor fixes

=== 0.8 / 2009-03-14

* Added -f/--fetch URI option; lets you fetch templates from the internet
* Added -l/--list option; list all installed templates
* Added -c/--config PATH option; lets you set config folder (default is ~/.slideshow)
* Moved S5 v11 blank package out of core/gem

=== 0.7.8 / 2009-03-09

* Added SLIDESHOWOPT env variable; lets you set default command line options (e.g. -o slides)
* Using Hoe Rake tasks to manage gem; adding required files and build script
* Move templates folder to top-level (out of lib/)
* Minor code clean-up

=== 0.7.7	/ 2009-03-02

* Added new helpers for syntax highlighting (using ultraviolet and coderay gems)

=== 0.7.6	/ 2009-02-24

* Added plugin/helpers support
* Added include and content_for helpers
* Added __SKIP__/__END__ pragmas

=== 0.7.5	/ 2009-02-19

* Updated s6 templates (added support for steps/incrementals)

=== 0.7.4	/ 2009-02-06

* Added sample template package generation for S5 v11 blank package

=== 0.7.3	/ 2009-02-04

* Added check for installed markdown libs/gems
* Added support for rdiscount, rpeg-markdown libs/gems

=== 0.7.2	/ 2009-01-27

* Added support for output directory switch -o/--output and relative or absolute source file [Thanks Jorge L. Cangas]

=== 0.7.1	/ 2009-01-26

* Fixed newline in manifests for file paths on unix bug

=== 0.7	/ 2009-01-26

* Adding support for custom template packages using manifests

=== 0.6.1	/ 2008-08-31

* Fixed gradient header bug [Thanks Suraj N. Kurapati]

=== 0.6	/ 2008-08-26

* Added support for custom templates

=== 0.5.2	/ 2008-07-23

* Pumped RedCloth gem dependency to use new 4.0 release

=== 0.5.1	/ 2008-07-08

* Added support for S6 JavaScript slide shows as new default

=== 0.5	/ 2008-07-03

* Added support for S5

=== 0.4.2	/ 2008-05-20

* Added escaping of code blocks and unescaping of html entities in highlighted code

=== 0.4.1	/ 2008-05-19

* {{{ and }}} shortcuts now supported standing in for <pre class='code'> and </pre>
* Added patch for h1 pattern

=== 0.4	/ 2008-05-17

* Added support for code syntax highlighting using Ultraviolet gem [Thanks zimbatm]

=== 0.3.1	/ 2008-05-17

* Switched markdown processor to maruku gem [Thanks zimbatm]
* Fix gem executable install for unix systems [Thanks zimbatm]

=== 0.3	/ 2008-03-09

* Added support for Markdown using BlueCloth
* Moved all templates into templates folder processed using erb (embedded ruby)

=== 0.2 /	2008-02-26

* Added theming support using svg gradients
* Added compatibility support for Opera Show (no browser plugin/addon required)

=== 0.1	/ 2008-02-17

* Everything is new. First release
