/// @description Sets a custom lighting uniform in the current shader
/// @param index
/// @param x
/// @param y
/// @param z
/// @param range
/// @param colour
/// @param alpha

if ( global.shader_focus == undefined ) exit;

var _index  = argument0;
var _x      = argument1;
var _y      = argument2;
var _z      = argument3;
var _range  = argument4;
var _colour = argument5;
var _alpha  = argument6;

var _posrange_uniform = undefined;
var _colour_uniform   = undefined;
switch( _index ) {
    case 0: _posrange_uniform = "u_vLightPosRange0"; _colour_uniform = "u_vLightColour0"; break;
    case 1: _posrange_uniform = "u_vLightPosRange1"; _colour_uniform = "u_vLightColour1"; break;
    case 2: _posrange_uniform = "u_vLightPosRange2"; _colour_uniform = "u_vLightColour2"; break;
    case 3: _posrange_uniform = "u_vLightPosRange3"; _colour_uniform = "u_vLightColour3"; break;
    case 4: _posrange_uniform = "u_vLightPosRange4"; _colour_uniform = "u_vLightColour4"; break;
    case 5: _posrange_uniform = "u_vLightPosRange5"; _colour_uniform = "u_vLightColour5"; break;
    case 6: _posrange_uniform = "u_vLightPosRange6"; _colour_uniform = "u_vLightColour6"; break;
    case 7: _posrange_uniform = "u_vLightPosRange7"; _colour_uniform = "u_vLightColour7"; break;
    default: return false; break;
}

s_shader_uniform_f( _posrange_uniform, _x, _y, _z, _range );
s_shader_uniform_f( _colour_uniform, colour_get_red( _colour )/255, colour_get_green( _colour )/255, colour_get_blue( _colour )/255, _alpha );
return true;