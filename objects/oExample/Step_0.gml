//Execute a step for the JSON. This clears event state, animates sprites and handles hyperlinks
scribble_step( json,   x, y,   mouse_x, mouse_y );

//Scan for any events from char_pos to char_pos+1
//Certain events ("break"/"pause") can interrupt scanning so the character position may end up less than expected
//This means we need to pass the character position back into the variable
//(Bear in mind that in compatibility mode, event callbacks are not scanned nor executed)
char_pos = scribble_events_scan_range( json, char_pos, char_pos + 0.2 );
    
//Run scripts for each type of event we found
//(Bear in mind that in compatibility mode, event callbacks are not scanned nor executed)
scribble_events_callback( json,   "sound", oExample_handle_sound,   "portrait", oExample_handle_portrait );
    
//Limit the character position to the maximum extent of the string
char_pos = min( char_pos, scribble_get_length( json ) );

//Set how many characters are visible
scribble_set_char_fade_in( json, char_pos, 1 );