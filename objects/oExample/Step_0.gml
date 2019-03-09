//Execute a step for the JSON. This handles the typewriter effect and events
scribble_step( json );

if ( scribble_typewriter_state( json ) == 1 ) scribble_typewriter_fade_out( json );