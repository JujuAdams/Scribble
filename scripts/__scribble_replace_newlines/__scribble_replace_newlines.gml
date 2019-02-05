/// @param string

var _string = argument0;

if ( SCRIBBLE_HASH_NEWLINE ) _string = string_replace_all( _string, "#", "\n" );
_string = string_replace_all( _string, "\n\r", "\n" );
_string = string_replace_all( _string, "\r\n", "\n" );
_string = string_replace_all( _string,   "\n", "\n" );
_string = string_replace_all( _string,  "\\n", "\n" );
_string = string_replace_all( _string,  "\\r", "\n" );

return _string;