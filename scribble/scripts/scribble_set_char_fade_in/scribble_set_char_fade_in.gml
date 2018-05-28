/// @param json
/// @param character
/// @param [smoothness]

var _json = argument[0];

_json[? "char fade t" ] = clamp( argument[1] / _json[? "length" ], 0, 1 );
if ( argument_count > 2 ) && ( argument[2] != undefined ) _json[? "char fade smoothness" ] = argument[2] / _json[? "length" ];