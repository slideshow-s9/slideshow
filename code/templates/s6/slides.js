/* Just an example for an all-in-one convenience include
   
   create your own slide.js to include your own extensions and
    change the startup (document ready) code as needed
    
    Tell us about your extentions or changes on the forum. Thank!
    Find the forum @ http://groups.google.com/group/webslideshow
 */


$.ajaxSetup({async: false});
$.getScript( 's6/slides.core.js' );
$.ajaxSetup({async: true});

$(document).ready(function(){
        
  if( $.browser.msie )
        {
          $( '.layout > *').hide();
          $( '.presentation').hide();
          
          $( '#microsoft' ).show();          
        }
        else
        {
	  
	  /* store possible slidenumber from hash */
	  /* todo: use regex to extract number
	       might be #slide1 or just #1
	  */
	  var gotoSlideNum = parseInt( window.location.hash.substring(1) );
	  debug( "gotoSlideNum=" + gotoSlideNum );
	  
         defaultCheck();
         addSlideIds();
         createControls();
         
         /* opera is the only browser currently supporting css projection mode */ 
         /* if( !$.browser.opera ) */
           notOperaFix();
					 
	  steps = collectSteps();
         
	  if( !isNaN( gotoSlideNum ))
          {
	    debug( "restoring slide on (re)load #: " + gotoSlideNum );
	    goTo( gotoSlideNum );
	  }
	  
	 
         if( defaultView == 'outline' ) 
		       toggle();
          
	  
	  
	   
         document.onkeyup = keys;
        }
     });
