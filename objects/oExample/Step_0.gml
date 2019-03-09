//Execute a step for the JSON. This handles the typewriter effect and events
scribble_step( json );

//Pingpong between fading in and fading out
if ( scribble_typewriter_get_state( json ) == 1 ) scribble_typewriter_out( json );
if ( scribble_typewriter_get_state( json ) == 2 ) scribble_typewriter_in( json );
//0 = State      : Text not yet faded in
//0 < State < 1  : Text is fading in
//1 = State      : Text fully visible
//1 < State < 2  : Text is fading out
//2 = State      : Text fully faded out