/// @param string
/// @param char
/// @param current_sep_char
/// @param current_sep_pos

var _str      = argument0;
var _char     = argument1;
var _sep_char = argument2;
var _sep_pos  = argument3;

var _pos = string_pos( _char, _str );
if ( _pos < _sep_pos ) && ( _pos > 0 ) return [ _char, _pos ];

return [ _sep_char, _sep_pos ];