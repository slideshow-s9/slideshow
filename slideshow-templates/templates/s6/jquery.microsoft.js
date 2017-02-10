

$(document).ready( function() {

    // 1) remove all content 
    $( 'body > *' ).remove();
          
    // 2) show banner  
    $( "<div>" ).html(
       "<p>"
       + "Microsoft's Internet Explorer browser has no built-in vector graphics machinery "
       + "required for 'loss-free' gradient background themes."
       + "</p>"       
       + "<p>"
       + "Please <span style='background: yellow'>upgrade to a better browser</span> "
       + "such as <a href='http://getfirefox.com'>Firefox</a>, <a href='http://www.opera.com/download'>Opera</a>, "
       + "<a href='http://google.com/chrome'>Chrome</a>, <a href='http://apple.com/safari/download'>Safari</a> or others "
       + "with built-in vector graphics machinery and much more. "
       + "(Learn more or post questions or comments "
       + "at the <a href='http://slideshow.rubyforge.org'>Slide Show (S9)</a> project site. Thanks!)"
       + "</p>"      
     )
     .css( {   
       border: 'red solid thick',
       padding: '1em',
       fontFamily: 'sans-serif',
       fontWeight: 'bold' } )
     .prependTo( 'body' );    
  }
);

