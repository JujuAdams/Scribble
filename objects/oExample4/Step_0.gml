//Limit the character position to the maximum extent of the string
char_pos = min( char_pos+0.5, scribble_get_length( scribble ) );

//Set how many characters are visible
scribble_set_char_fade_in( scribble, char_pos, 1 );