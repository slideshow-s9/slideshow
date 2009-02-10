   var snum = 1;      /* current slide # (non-zero based index e.g. starting with 1) */
   var smax = 1;      /* max number of slides */
   var s6mode = true; /* are we in slide mode (in contrast to outline mode)? */ 
   var defaultView = 'slideshow'; /* slideshow | outline */
   
 function showHide(action)
 {
	switch( action ) {
	  case 's': $( '#navLinks' ).css( 'visibility', 'visible' );  break;
	  case 'h': $( '#navLinks' ).css( 'visibility', 'hidden' );   break;
    case 'c':  /* toggle control panel */
      if( $( '#navLinks' ).css( 'visibility' ) != 'visible' )
         $( '#navLinks' ).css( 'visibility', 'visible' );
      else
         $( '#navLinks' ).css( 'visibility', 'hidden' );
	    break; 
  }
 }  
   
  function currentSlide() {
	 
    $( '#currentSlide' ).html( '<a id="plink" href="">' + 
		     '<span id="csHere">' + snum + '<\/span> ' + 
		     '<span id="csSep">\/<\/span> ' + 
		     '<span id="csTotal">' + smax + '<\/span>' +
		     '<\/a>' );		
  }    
   

  function permaLink() {
	   $('#plink').get(0).href = window.location.pathname + '#slide' + snum;
  }

 function goTo( target ) {
	 if( target > smax || target == snum ) return;
	 go( target - snum );
 }
 
 function go( step ) {
  
	var cid = '#slide' + snum;

	if (step != 'j') {
		snum += step;
		if( snum > smax ) snum = smax;
		if (snum < 1) snum = 1;
	} else
   snum = parseInt( $( '#jumplist' ).val() );
  
	var nid = '#slide' + snum;
  
  $( cid ).hide();
  $( nid ).show();
  
  $('#jumplist').get(0).selectedIndex = (snum-1);
  currentSlide();
  permaLink(); 
}


function toggle() {
 
  /* get stylesheets */
	var slides  = $('#slideProj').get(0);
	var outline = $('#outlineStyle').get(0);
	
  if( !slides.disabled ) {
		slides.disabled = true;
		outline.disabled = false;
		s6mode = false;
    $('.slide').each( function() { $(this).show(); } );
	} else {
		slides.disabled = false;
		outline.disabled = true;
		s6mode = true;
    $('.slide').each( function(i) {
      if( i == (snum-1) )
        $(this).show();
      else
        $(this).hide();
    });
	}
}
 
 
   function populateJumpList() {
    
     var list = $('#jumplist').get(0);
    
     $( '.slide' ).each( function(i) {              
       list.options[list.length] = new Option( (i+1)+' : '+ $(this).find('h1').text(), (i+1) );
     });
   } 
   
   function createControls() {	  
  
   	 $('#controls').html(  '<div id="navLinks">' +
	'<a accesskey="t" id="toggle" href="#">&#216;<\/a>' +
	'<a accesskey="z" id="prev" href="#">&laquo;<\/a>' +
	'<a accesskey="x" id="next" href="#">&raquo;<\/a>' +
	'<div id="navList"><select id="jumplist" /><\/div>' +
	'<\/div>' ); 
      
      $('#controls').mouseover( function() { showHide('s'); } );
      $('#controls').mouseout( function()  { showHide('h'); } );
      $('#toggle').click( function() { toggle(); } );
      $('#prev').click( function() { go(-1); } );
      $('#next').click( function() { go(1); } );
      
      $('#jumplist').change( function() { go('j'); } );
  	
      populateJumpList();     
      currentSlide();
   }
   
   function addSlideIds() {
     $( '.slide' ).each( function(i) {
       $(this).attr( 'id', 'slide'+(i+1) );
     });
       
     smax = $( '.slide' ).length;
   }
   
   function notOperaFix() {
	     
	     $('#slideProj').attr( 'media','screen' );
              
	     var outline = $('#outlineStyle').get(0);
	     outline.disabled = true;
    }    
     
  
  function defaultCheck() {
     $( 'meta' ).each( function() {
        if( $(this).attr( 'name' ) == 'defaultView' )
          defaultView = $(this).attr( 'content' );
     } );
  }
  
  function keys(key) {
	if (!key) {
		key = event;
		key.which = key.keyCode;
	}
	if (key.which == 84) {
		toggle();
		return;
	}
	if (s6mode) {
		switch (key.which) {
			case 32: // spacebar
			case 34: // page down
			case 39: // rightkey
			case 40: // downkey
					go(1);
				  break;
			case 33: // page up
			case 37: // leftkey
			case 38: // upkey
					go(-1);
				  break;
      case 36: // home
				goTo(1);
				break;
			case 35: // end
				goTo(smax);
				break;   
			case 67: // c
				showHide('c');
				break;
		}
	}
	return false;
}

   
$(document).ready(function(){
        
  if( $.browser.msie )
        {
          $( '.layout > *').hide();
          $( '.presentation').hide();
          
          $( '#microsoft' ).show();          
        }
        else
        {
         defaultCheck();
         addSlideIds();
         createControls();
         
         /* opera is the only browser currently supporting css projection mode */ 
         /* if( !$.browser.opera ) */
           notOperaFix();
         
         if( defaultView == 'outline' ) 
		       toggle();
           
         document.onkeyup = keys;
        }
     });
