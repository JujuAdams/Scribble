/// Sets the relative position of the textbox for a Scribble data structure
///
/// This script returns the positions of each corner of a box that encapsulates the text.
/// It returns an 8-element array. You can use the SCRIBBLE_BOX enum to conveniently reference each coordinate.
///
/// @param json             The Scribble data structure to use
/// @param [x]              The x position in the room to draw at. Defaults to 0
/// @param [y]              The y position in the room to draw at. Defaults to 0
/// @param [leftMargin]     The additional space to add to the left-hand side of the box. Positive values create more space. Defaults to 0
/// @param [topMargin]      The additional space to add to the top of the box. Positive values create more space. Defaults to 0
/// @param [rightMargin]    The additional space to add to the right-hand side of the box. Positive values create more space. Defaults to 0
/// @param [bottomMargin]   The additional space to add to the bottom of the box. Positive values create more space. Defaults to 0
/// @param [xscale]         The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]         The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]          The rotation of the text. Defaults to the value set in __scribble_config()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _json   = argument[0];
var _x      = argument[1];
var _y      = argument[2];
var _left   = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _top    = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _right  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _bottom = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;
var _xscale = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : 1;
var _yscale = ((argument_count > 8) && (argument[8] != undefined))? argument[8] : 1;
var _angle  = ((argument_count > 9) && (argument[9] != undefined))? argument[9] : 0;

if ( !is_real(_json) || !ds_exists(_json, ds_type_list) )
{
    show_error("Scribble:\nScribble data structure \"" + string(_json) + "\" doesn't exist!\n ", false);
    exit;
}

if ((_xscale == 1) && (_yscale == 1) && (_angle == 0))
{
    //Avoid using matrices if we can
    var _l = _x + _json[| __SCRIBBLE.LEFT   ] - _left;
    var _t = _y + _json[| __SCRIBBLE.TOP    ] - _top;
    var _r = _x + _json[| __SCRIBBLE.RIGHT  ] + _right;
    var _b = _y + _json[| __SCRIBBLE.BOTTOM ] + _bottom;
    
    return [ _l, _t,
             _r, _t,
             _l, _b,
             _r, _b ];
}

var _matrix = matrix_build(_x,_y,0,   0,0,_angle,   _xscale,_yscale,1);

var _l = _json[| __SCRIBBLE.LEFT   ] - _left;
var _t = _json[| __SCRIBBLE.TOP    ] - _top;
var _r = _json[| __SCRIBBLE.RIGHT  ] + _right;
var _b = _json[| __SCRIBBLE.BOTTOM ] + _bottom;

var _result = array_create(8);
var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); _result[SCRIBBLE_BOX.X0] = _vertex[0]; _result[SCRIBBLE_BOX.Y0] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); _result[SCRIBBLE_BOX.X1] = _vertex[0]; _result[SCRIBBLE_BOX.Y1] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); _result[SCRIBBLE_BOX.X2] = _vertex[0]; _result[SCRIBBLE_BOX.Y2] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); _result[SCRIBBLE_BOX.X3] = _vertex[0]; _result[SCRIBBLE_BOX.Y3] = _vertex[1];

return _result;