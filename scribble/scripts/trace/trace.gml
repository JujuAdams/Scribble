/// @description TRACE general-purpose output (safe for non-string arguments)
/// @param value
/// @param [value...]

var _str = "";
for( var _i = 0; _i < argument_count; _i++ ) _str += string_ext( argument[_i] );
__trace_master( _str );
return _str;