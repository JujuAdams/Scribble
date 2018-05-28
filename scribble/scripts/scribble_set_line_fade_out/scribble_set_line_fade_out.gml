/// @param json
/// @param line
/// @param [smoothness]

var _json = argument[0];

_json[? "line fade t" ] = 1 + clamp( argument[1] / _json[? "lines" ], 0, 1 );
if ( argument_count > 2 ) && ( argument[2] != undefined ) _json[? "line fade smoothness" ] = argument[2] / _json[? "lines" ];