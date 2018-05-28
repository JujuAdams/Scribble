/// @description Sets the shader used to draw a particular SCRIBBLE
///              Pass in no additional arguments to reset the shader to the default
///              
/// @param json
/// @param [shader]
/// @param [smoothness]
/// @param [fade_type]

var _json       = argument[0];
var _shader     = ((argument_count < 2) || (argument[1] == undefined))?  shd_scribble_basic : argument[1];
var _smoothness = ((argument_count < 3) || (argument[2] == undefined))?                   0 : argument[2];
var _fade_type  = ((argument_count < 4) || (argument[3] == undefined))? E_SCRIBBLE_FADE.OFF : argument[3];

if ( _shader == shd_scribble_fade_char ) _fade_type = E_SCRIBBLE_FADE.PER_CHAR;
if ( _shader == shd_scribble_fade_line ) _fade_type = E_SCRIBBLE_FADE.PER_LINE;

_json[? "shader"            ] = _shader;
_json[? "shader smoothness" ] = _smoothness;
_json[? "shader fade"       ] = _fade_type;