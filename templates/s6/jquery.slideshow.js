
var Slideshow = {};


/************************************
 * lets you define your own "global" transition function
 *   passes in a reference to from and to slide wrapped in jQuery wrapper
 */

Slideshow.transition = function( $from, $to ) {
  $from.hide();
  $to.show();
}

/***********************
 * sample custom transition using scrollUp effect
 * inspired by Karl Swedberg's Scroll Up Headline Reader jQuery Tutorial[1]
 * [1] http://docs.jquery.com/Tutorials:Scroll_Up_Headline_Reader
 */

function transitionSlideUpSlideDown( $from, $to ) {
   $from.slideUp( 500, function() { $to.slideDown( 1000 ); } );
}
	
function transitionFadeOutFadeIn( $from, $to ) {
	 $from.fadeOut( 500 );
   $to.fadeIn( 500 );			
}

function transitionScrollUp( $from, $to ) {   
  var cheight = $from.outerHeight();

  // hide scrollbar during animation
  $( 'body' ).css( 'overflow-y', 'hidden' );

  $to.css( 'top', cheight+'px' );
  $to.show();

  $from.animate( {top: -cheight}, 'slow' );
  $to.animate( {top: 0}, 'slow', function() {
     $from.hide().css( 'top', '0px');

     // restore possible scrollbar 
     $( 'body' ).css( 'overflow-y', 'auto' );
  }); 
}

Slideshow.init = function( options ) {

  var settings = $.extend({
     mode              : 'slideshow', // slideshow | outline | autoplay
     projectionStyleId : '#styleProjection',
	   screenStyleId     : '#styleScreen',
     titleSelector     : 'h1',      
     slideSelector     : '.slide',   // dummy (not yet working)
     stepSelector      : '.step',    // dummy (not yet working)
     debug             :  false
  }, options || {});

  settings.isProjection = true; // are we in projection (slideshow) mode (in contrast to screen (outline) mode)?     
  settings.snum = 1;      // current slide # (non-zero based index e.g. starting with 1)
  settings.smax = 1;      // max number of slides 
  settings.incpos = 0;    // current step in slide  
  settings.steps  = null;
  settings.autoplayInterval = null; 
   
  function debug( msg ) 
  {
    if( window.console && window.console.log )
      window.console.log( '[debug] ' + msg ); 
  }   

  function showHide( action )
  {
    var $navLinks = $( '#navLinks' )  
       
    switch( action ) {
      case 's': $navLinks.css( 'visibility', 'visible' );  break;
      case 'h': $navLinks.css( 'visibility', 'hidden' );   break;
      case 'c':  /* toggle control panel */
          if( $navLinks.css( 'visibility' ) != 'visible' )
             $navLinks.css( 'visibility', 'visible' );
          else
             $navLinks.css( 'visibility', 'hidden' );
          break; 
    }
  }  
   
  function updateCurrentSlideCounter()
  { 
      $( '#currentSlide' ).html( settings.snum + '/' + settings.smax );
  }
  
  function updateJumpList()
  {
      $('#jumplist').get(0).selectedIndex = (settings.snum-1);
  }
  
  function updatePermaLink()
  {
      // todo: unify hash marks??; use #1 for div ids instead of #slide1? 
      window.location.hash = '#'+settings.snum;
  }

  function goTo( target )
  {
       if( target > settings.smax || target == settings.snum ) return;
       go( target - settings.snum );
  }
 
  function go( dir )
  {
    debug( 'go: ' + dir );
  
    if( dir == 0 ) return;  /* same slide; nothing to do */

    var cid = '#slide' + settings.snum;   /* current slide (selector) id */
    var csteps = settings.steps[settings.snum-1];  /* current slide steps array */

    /* remove all step and stepcurrent classes from current slide */
   if( csteps.length > 0) {
     $( csteps ).each( function() {
       $(this).removeClass( 'step' ).removeClass( 'stepcurrent' );
     } );
   }

  /* set snum to next slide */
  settings.snum += dir;
  if( settings.snum > settings.smax ) settings.snum = settings.smax;
  if( settings.snum < 1 ) settings.snum = 1;
  
  var nid = '#slide' + settings.snum;  /* next slide (selector) id */
  var nsteps = settings.steps[settings.snum-1]; /* next slide steps array */															  
  
	if( dir < 0 ) /* go backwards? */
	{
		settings.incpos = nsteps.length;
		/* mark last step as current step */
		if( nsteps.length > 0 ) 
			$( nsteps[settings.incpos-1] ).addClass( 'stepcurrent' );		
	}
	else /* go forwards? */
	{
		settings.incpos = 0;
	  if( nsteps.length > 0 ) {
		  $( nsteps ).each( function() {
				$(this).addClass( 'step' ).removeClass( 'stepcurrent' );
			} );
		}
	}	
	
  if( !(cid == nid) ) {
    debug( "transition from " + cid + " to " + nid );
    Slideshow.transition( $( cid ), $( nid ) );
  }
  
  updateJumpList();
  updateCurrentSlideCounter();
  updatePermaLink(); 
}

 function subgo( dir )
 {
	debug( 'subgo: ' + dir + ', incpos before: ' + settings.incpos + ', after: ' + (settings.incpos+dir) );
	
	var csteps = settings.steps[settings.snum-1]; /* current slide steps array */
	
	if( dir > 0)
  {  /* go forward? */
		if( settings.incpos > 0 )
      $( csteps[settings.incpos-1] ).removeClass( 'stepcurrent' );
		$( csteps[settings.incpos] ).removeClass( 'step').addClass( 'stepcurrent' ); 
		settings.incpos++;
	}
  else
  { /* go backwards? */
		settings.incpos--;
		$( csteps[settings.incpos] ).removeClass( 'stepcurrent' ).addClass( 'step' );
		if( settings.incpos > 0 )
      $( csteps[settings.incpos-1] ).addClass( 'stepcurrent' );
	}
}


function notOperaFix()
{          
   $( settings.projectionStyleId ).attr( 'media','screen' );
              
   var styleScreen = $( settings.screenStyleId ).get(0);
   styleScreen.disabled = true;
}    


function toggle()
{
  // toggle between projection (slide show) mode
  //   and screen (outline) mode

  // get stylesheets 
	var styleProjection  = $( settings.projectionStyleId ).get(0);
	var styleScreen      = $( settings.screenStyleId ).get(0);
	
  if( !styleProjection.disabled )
  {
		styleProjection.disabled = true;
		styleScreen.disabled     = false;
		settings.isProjection    = false;
    $('.slide').each( function() { $(this).show(); } );
	}
  else
  {
		styleProjection.disabled = false;
		styleScreen.disabled     = true;
		settings.isProjection    = true;
    $('.slide').each( function(i) {
      if( i == (settings.snum-1) )
        $(this).show();
      else
        $(this).hide();
    });
	}
}
 
   function populateJumpList() {
    
     var list = $('#jumplist').get(0);
    
     $( '.slide' ).each( function(i) {
       var text = $(this).find( settings.titleSelector ).text();
       list.options[list.length] = new Option( (i+1)+' : '+ text, (i+1) );
     });
   } 
   
   function createControls()
   {	  
     // todo: make layout into an id (not class?)
     //  do we need or allow more than one element?
     
  
     // if no div.layout exists, create one
     if( $( '.layout' ).length == 0 )
        $( "<div class='layout'></div>").appendTo( 'body' );
  
     $( '.layout' )
	    .append( "<div id='controls'>" )
	    .append( "<div id='currentSlide'>" );
 
      var $controls = $( '#controls' )
    
   	 $controls.html(  '<div id="navLinks">' 
	    + '<a accesskey="t" id="toggle" href="#">&#216;<\/a>' 
	    + '<a accesskey="z" id="prev" href="#">&laquo;<\/a>' 
	    + '<a accesskey="x" id="next" href="#">&raquo;<\/a>' 
	    + '<div id="navList"><select id="jumplist" /><\/div>' 
	    + '<\/div>' ); 
      
      $controls.hover( function() { showHide('s') }, function() { showHide('h') });
      $('#toggle').click( function() { toggle(); } );
      $('#prev').click( function() { go(-1); } );
      $('#next').click( function() { go(1); } );
       
      $('#jumplist').change( function() { goTo( parseInt( $( '#jumplist' ).val() )); } );
  	
      populateJumpList();     
      updateCurrentSlideCounter();
      updatePermaLink(); 
   }
  
  function toggleSlideNumber()
  {
     // toggle slide number/counter
     $( '#currentSlide' ).toggle();
  }
  
  function toggleFooter()
  {
     $( '#footer').toggle(); 
  }
  
  
  function keys(key)
  {
	if (!key) {
		key = event;
		key.which = key.keyCode;
	}
	if (key.which == 84) {
		toggle();  // toggle between project and screen css media mode 
		return;
	}
	if( settings.isProjection ) {
		switch (key.which) {
			case 32: // spacebar
			case 34: // page down
			case 39: // rightkey
			case 40: // downkey
				
        var csteps = settings.steps[settings.snum-1]; /* current slide steps array */
        
				if ( !csteps || settings.incpos >= csteps.length ) {
					go(1);
				} else {
					subgo(1);
				}
				break;
			case 33: // page up
			case 37: // leftkey
			case 38: // upkey
					
					if( !settings.steps[settings.snum-1] || settings.incpos <= 0 ) {
					  go(-1);
				  } else {
					  subgo(-1);
					}
				  break;
      case 36: // home
				goTo(1);
				break;
			case 35: // end
				goTo(settings.smax);
				break;   
			case 67: // c
				showHide('c');  // toggle controls (navlinks,navlist)
				break;
      case 65: //a
			case 80: //p
			case 83: //s
				toggleAutoplay();
				break;
      case 70: //f
        toggleFooter();
        break;
      case 78: // n
        toggleSlideNumber();
        break;
      case 68: // d
        toggleDebug();
        break;
		}
	}
}

function autoplay()
{
	// suspend autoplay in outline view (just slideshow view)
	if( !settings.isProjection )
	  return;

     // next slide/step, please
     var csteps = settings.steps[settings.snum-1]; // current slide steps array 
     if( !csteps || settings.incpos >= csteps.length ) {
			  if( settings.snum >= settings.smax )
           goTo( 1 );   // reached end of show? start with 1st slide again (for endless cycle)
        else
           go(1);
	   }
     else {
			  subgo(1);
	   }
}

function toggleDebug()
{
   settings.debug = !settings.debug;
   doDebug();
}

function doDebug()
{
   // fix/todo: save background into oldbackground
   //  so we can restore later 
   
   if( settings.debug == true )
   {
      $( '#header' ).css( 'background', '#FCC' );
      $( '#footer' ).css( 'background', '#CCF' );
      $( '#controls' ).css( 'background', '#BBD' );
      $( '#currentSlide' ).css( 'background', '#FFC' ); 
   }
   else
   {
      $( '#header' ).css( 'background', 'transparent' );
      $( '#footer' ).css( 'background', 'transparent' );
      $( '#controls' ).css( 'background', 'transparent' );
      $( '#currentSlide' ).css( 'background', 'transparent' );       
   }
}

	 
function toggleAutoplay()
{
  if( settings.autoplayInterval )
	{
		clearInterval( settings.autoplayInterval );
		settings.autoplayInterval = null;
	}
	else
	{
	   settings.autoplayInterval = setInterval ( autoplay, 2000 );
	}
}



function collectStepsWorker(obj) {
	
	var steps = new Array();
	if( !obj ) 
		return steps;
	
	$(obj).children().each( function() {
	  if( $(this).hasClass( 'step' ) ) {
			
			debug( 'step found for ' + this.tagName );
			$(this).removeClass( 'step' );

			/* don't add enclosing list; instead add step class to all list items/children */
			if( $(this).is( 'ol,ul' ) ) {
				debug( '  ol or ul found; adding auto steps' );
				$(this).children().addClass( 'step' );
			}
			else
			{
				steps.push( this )
			}
		}
	 	
		steps = steps.concat( collectStepsWorker(this) );
	});
	
  return steps;
}

function collectSteps() {
	
	var steps = new Array();

  $slides.each(	function(i) {
		debug ( 'collectSteps for ' + this.id + ':' );
		steps[i] = collectStepsWorker( this );
  });
	
	$( steps ).each( function(i) {
	  debug( 'slide ' + (i+1) + ': found ' + this.length + ' steps' );	
	});
       
  return steps;
}


function addClicker() {
    // if you click on heading of slide -> go to next slide (or next step)
   
   $( settings.titleSelector, $slides ).click( function() { 
      if( !settings.isProjection )  // suspend clicker in outline view (just slideshow view)
	       return;
     
      var csteps = settings.steps[settings.snum-1]; // current slide steps array 
			if ( !csteps || settings.incpos >= csteps.length ) 
				 go(1);
			else 
				 subgo(1);
   } ); 
}

function addSlideIds() {
     $slides.each( function(i) {
        this.id = 'slide'+(i+1);
     });
   }
   
   // init code here
   
    // store possible slidenumber from hash */
	  // todo: use regex to extract number
	  //    might be #slide1 or just #1
	 
	  var gotoSlideNum = parseInt( window.location.hash.substring(1) );
	  debug( "gotoSlideNum=" + gotoSlideNum );
  
   var $slides = $( '.slide' );  
   settings.smax = $slides.length;
   
   addSlideIds();
   settings.steps = collectSteps();
     
   createControls();
   
   addClicker();
         
   /* opera is the only browser currently supporting css projection mode */ 
   /* if( !$.browser.opera ) */
   notOperaFix();

   if( !isNaN( gotoSlideNum ))
   {
	    debug( "restoring slide on (re)load #: " + gotoSlideNum );
	    goTo( gotoSlideNum );
	 }
	           
   if( settings.mode == 'outline' ) 
     toggle();
   else if( settings.mode == 'autoplay' )
     toggleAutoplay();
  
  
   if( settings.debug == true )
     doDebug();
                
   document.onkeyup = keys;

} // end Slideshow
