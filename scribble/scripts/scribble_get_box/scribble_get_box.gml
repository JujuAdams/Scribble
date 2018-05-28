/// @param json
/// @param [x]
/// @param [y]
/// @param [left_margin]
/// @param [top_margin]
/// @param [right_margin]
/// @param [bottom_margin]

var _json   = argument[0];
var _x      = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : 0;
var _y      = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 0;
var _left   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _top    = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _right  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _bottom = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;

return [ _x + _json[? "left"  ] - _left , _y + _json[? "top"    ] - _top,
         _x + _json[? "right" ] + _right, _y + _json[? "bottom" ] + _bottom ];