/// Sets the relative position of the textbox for a Scribble data structure
/// 
/// 
/// @param scribbleArray    The Scribble data structure to use
/// @param x                The x position in the room to draw at. Defaults to 0
/// @param y                The y position in the room to draw at. Defaults to 0
/// @param [leftMargin]     The additional space to add to the left-hand side of the box. Positive values create more space. Defaults to 0
/// @param [topMargin]      The additional space to add to the top of the box. Positive values create more space. Defaults to 0
/// @param [rightMargin]    The additional space to add to the right-hand side of the box. Positive values create more space. Defaults to 0
/// @param [bottomMargin]   The additional space to add to the bottom of the box. Positive values create more space. Defaults to 0
/// 
/// All optional arguments accept <undefined> to indicate that the default value should be used.
/// 
/// 
/// This script returns the positions of each corner of a box that encapsulates the text.
/// It returns an 8-element array. You can use the SCRIBBLE_BOX enum to reference each coordinate pair.

var _scribble_array = argument[0];
var _x              = argument[1];
var _y              = argument[2];
var _margin_l       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _margin_t       = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _margin_r       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _margin_b       = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;

if (!scribble_exists(_scribble_array))
{
    show_error("Scribble:\nScribble data structure \"" + string(_scribble_array) + "\" doesn't exist!\n ", false);
    exit;
}

switch(global.__scribble_state_box_halign)
{
    case fa_left:
        var _box_l = 0;
        var _box_r = _scribble_array[__SCRIBBLE.WIDTH];
    break;
    
    case fa_center:
        var _box_l = -_scribble_array[__SCRIBBLE.WIDTH] div 2;
        var _box_r = -_box_l;
    break;
    
    case fa_right:
        var _box_l = -_scribble_array[__SCRIBBLE.WIDTH];
        var _box_r = 0;
    break;
}

switch(global.__scribble_state_box_valign)
{
    case fa_top:
        var _box_t = 0;
        var _box_b = _scribble_array[__SCRIBBLE.HEIGHT];
    break;
    
    case fa_middle:
        var _box_t = -_scribble_array[__SCRIBBLE.HEIGHT] div 2;
        var _box_b = -_box_t;
    break;
    
    case fa_bottom:
        var _box_t = -_scribble_array[__SCRIBBLE.HEIGHT];
        var _box_b = 0;
    break;
}

if ((global.__scribble_state_xscale == 1)
&&  (global.__scribble_state_yscale == 1)
&&  (global.__scribble_state_angle == 0))
{
    //Avoid using matrices if we can
    var _l = _x + _box_l - _margin_l;
    var _t = _y + _box_t - _margin_t;
    var _r = _x + _box_r + _margin_r;
    var _b = _y + _box_b + _margin_b;
    
    return [_l, _t,
            _r, _t,
            _l, _b,
            _r, _b ];
}

var _matrix = matrix_build(_x, _y, 0, 
                           0, 0, global.__scribble_state_angle,
                           global.__scribble_state_xscale, global.__scribble_state_yscale, 1);

var _l = _box_l - _margin_l;
var _t = _box_t - _margin_t;
var _r = _box_r + _margin_r;
var _b = _box_b + _margin_b;

var _result = array_create(SCRIBBLE_BOX.__SIZE);
var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); _result[@ SCRIBBLE_BOX.TL_X] = _vertex[0]; _result[@ SCRIBBLE_BOX.TL_Y] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); _result[@ SCRIBBLE_BOX.TR_X] = _vertex[0]; _result[@ SCRIBBLE_BOX.TR_Y] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); _result[@ SCRIBBLE_BOX.BL_X] = _vertex[0]; _result[@ SCRIBBLE_BOX.BL_Y] = _vertex[1];
var _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); _result[@ SCRIBBLE_BOX.BR_X] = _vertex[0]; _result[@ SCRIBBLE_BOX.BR_Y] = _vertex[1];
return _result;