//Execute a step for the JSON. This clears event state, animates sprites and handles hyperlinks
scribble_step( json,   x, y,   mouse_x, mouse_y );

//Limit the character position to the maximum extent of the string
char_pos = min( char_pos+0.5, scribble_get_length( json ) );

//Set how many characters are visible
scribble_set_char_fade_in( json, char_pos, 1 );