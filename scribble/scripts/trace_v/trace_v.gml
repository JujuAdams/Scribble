/// @description TRACE output with extra origin data (safe for non-string arguments)
/// @param value
/// @param [value...]

var _str = TRACE_TIME_PADDED + TRACE_DIV + object_get_name( object_index ) + ":" + string( id ) + TRACE_DIV;
for( var _i = 0; _i < argument_count; _i++ ) _str += string_ext( argument[_i] );
__trace_master( _str );
return _str;