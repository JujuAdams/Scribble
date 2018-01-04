/// @param value
/// @param [value...]

var _str = "";
for( var _i = 0; _i < argument_count; _i++ ) _str += string_ext( argument[_i] );
return _str;