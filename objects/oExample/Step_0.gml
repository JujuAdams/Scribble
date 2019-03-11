//Update the text. This handles animation and events
scribble_step( text );

//Swap between fading in and fading out
if ( scribble_typewriter_get_state( text ) == 1 ) scribble_typewriter_out( text );
if ( scribble_typewriter_get_state( text ) == 2 ) scribble_typewriter_in( text );
//0 = State      : Text not yet faded in
//0 < State < 1  : Text is fading in
//1 = State      : Text fully visible
//1 < State < 2  : Text is fading out
//2 = State      : Text fully faded out