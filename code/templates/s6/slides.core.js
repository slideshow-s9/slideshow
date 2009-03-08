   var snum = 1;      /* current slide # (non-zero based index e.g. starting with 1) */
   var smax = 1;      /* max number of slides */
	 var incpos = 0;    /* current step in slide */ 
   var s6mode = true; /* are we in slide mode (in contrast to outline mode)? */ 
   var defaultView = 'slideshow'; /* slideshow | outline */
   

 function debug( msg )	 
 {
	 /* uncomment to enable debug messages in console such as Firebug */
	 /* console.log( '[debug] ' + msg ); */
 }	
	 
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
   
  function updateCurrentSlideCounter() {
	 
    $( '#currentSlide' ).html( '<a id="plink" href="">' + 
		     '<span id="csHere">' + snum + '<\/span> ' + 
		     '<span id="csSep">\/<\/span> ' + 
		     '<span id="csTotal">' + smax + '<\/span>' +
		     '<\/a>' );		
  }    
   

  function updatePermaLink() {
	   $('#plink').get(0).href = window.location.pathname + '#slide' + snum;
  }

 function goTo( target ) {
	 if( target > smax || target == snum ) return;
	 go( target - snum );
 }
 
 function go( dir ) {

	debug( 'go: ' + dir );
  
	if( dir == 0 ) return;  /* same slide; nothing to do */
	
	var cid = '#slide' + snum;   /* current slide (selector) id */
  var csteps = steps[snum-1];  /* current slide steps array */
															   
  /* remove all step and stepcurrent classes from current slide */
	if( csteps.length > 0) {
		$( csteps ).each( function() {
			$( this ).removeClass( 'step' ).removeClass( 'stepcurrent' );
		} );
	}

  /* set snum to next slide */
	snum += dir;
	if( snum > smax ) snum = smax;
	if (snum < 1) snum = 1;
  
	var nid = '#slide' + snum;  /* next slide (selector) id */
  var nsteps = steps[snum-1]; /* next slide steps array */															  
  
	if( dir < 0 ) /* go backwards? */
	{
		incpos = nsteps.length;
		/* mark last step as current step */
		if( nsteps.length > 0 ) 
			$( nsteps[incpos-1] ).addClass( 'stepcurrent' );		
	}
	else /* go forwards? */
	{
		incpos = 0;
	  if( nsteps.length > 0 ) {
		  $( nsteps ).each( function() {
				$(this).addClass( 'step' ).removeClass( 'stepcurrent' );
			} );
		}
	}	
	
  $( cid ).hide();
  $( nid ).show();
  
  $('#jumplist').get(0).selectedIndex = (snum-1);
  updateCurrentSlideCounter();
  updatePermaLink(); 
}

 function subgo( dir ) {
	
	debug( 'subgo: ' + dir + ', incpos before: ' + incpos + ', after: ' + (incpos+dir) );
	
	var csteps = steps[snum-1]; /* current slide steps array */
	
	if( dir > 0) {  /* go forward? */
		if( incpos > 0 ) $( csteps[incpos-1] ).removeClass( 'stepcurrent' );
		$( csteps[incpos] ).removeClass( 'step').addClass( 'stepcurrent' ); 
		incpos++;
	} else { /* go backwards? */
		incpos--;
		$( csteps[incpos] ).removeClass( 'stepcurrent' ).addClass( 'step' );
		if( incpos > 0 ) $( csteps[incpos-1] ).addClass( 'stepcurrent' );
	}
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
      
      $('#jumplist').change( function() { goTo( parseInt( $( '#jumplist' ).val() )); } );
  	
      populateJumpList();     
      updateCurrentSlideCounter();
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
				
				if (!steps[snum-1] || incpos >= steps[snum-1].length) {
					go(1);
				} else {
					subgo(1);
				}
				break;
			case 33: // page up
			case 37: // leftkey
			case 38: // upkey
					
					if( !steps[snum-1] || incpos <= 0 ) {
					  go(-1);
				  } else {
					  subgo(-1);
					}
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

  $( '.slide' ).each(	function(i) {
		debug ( $(this).attr( 'id' ) + ':' );
		steps[i] = collectStepsWorker( this );
  });
	
	$( steps ).each( function(i) {
	  debug( 'slide ' + (i+1) + ': found ' + this.length + ' steps' );	
	});
       
  return steps;
}

