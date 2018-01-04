/// @description TRACE pop-up output (safe for non-string arguments)
/// @param value
/// @param [value...]

var _str = "";
for( var _i = 0; _i < argument_count; _i++ ) _str += string_ext( argument[_i] );
__trace_master( TRACE_TIME_PADDED + TRACE_DIV + object_get_name( object_index ) + ":" + string( id ) + " <LOUD>" + TRACE_DIV + _str );
show_message( _str );
return _str;