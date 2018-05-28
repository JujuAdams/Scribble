/// @param string

var _string = argument0;

if ( SCRIBBLE_HASH_NEWLINE ) _string = string_replace_all( _string, "#", chr(13) );
_string = string_replace_all( _string, chr(10)+chr(13), chr(13) );
_string = string_replace_all( _string, chr(13)+chr(10), chr(13) );
_string = string_replace_all( _string,         chr(10), chr(13) );
_string = string_replace_all( _string,           "\\n", chr(13) );

return _string;