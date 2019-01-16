/// @param json
/// @param x
/// @param y
/// @param [leftMargin]
/// @param [topMargin]
/// @param [rightMargin]
/// @param [bottomMargin]

var _json   = argument[0];
var _x      = argument[1];
var _y      = argument[2];
var _left   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _top    = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _right  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _bottom = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;

return [ _x + _json[? "left"  ] - _left , _y + _json[? "top"    ] - _top,
         _x + _json[? "right" ] + _right, _y + _json[? "bottom" ] + _bottom ];