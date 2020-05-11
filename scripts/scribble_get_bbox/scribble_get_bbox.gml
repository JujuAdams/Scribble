/// Gets the position of the axis-aligned bounding box for a text element
/// 
/// Returns: 6-element array containing the positions of the bounding box for a text element
/// @param string/textElement   The text to get the bounding box for. Alternatively, you can pass a text element into this argument from a previous call to scribble_draw().
/// @param x                    x-position in the room to draw at
/// @param y                    y-position in the room to draw at
/// @param [leftMargin]         Extra space on the left-hand side of the textbox. Positive values create more space. Defaults to 0
/// @param [topMargin]          Extra space on the top of the textbox. Positive values create more space. Defaults to 0
/// @param [rightMargin]        Extra space on the right-hand side of the textbox. Positive values create more space. Defaults to 0
/// @param [bottomMargin]       Extra space on the bottom of the textbox. Positive values create more space. Defaults to 0
/// 
/// The padding arguments can be given the value undefined to indicate that the default value should be used.
/// 
/// The array returned by scribble_get_bbox() has 6 elements as defined by the enum SCRIBBLE_BBOX.

enum SCRIBBLE_BBOX
{
    L, T, R, B, W, H,
    __SIZE
}

var _scribble_array = argument[0];
var _x              = argument[1];
var _y              = argument[2];
var _margin_l       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
var _margin_t       = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
var _margin_r       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
var _margin_b       = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;

var _quad = scribble_get_quad(_scribble_array, _x, _y, _margin_l, _margin_t, _margin_r, _margin_b);

var _l = min(_quad[SCRIBBLE_QUAD.X0], _quad[SCRIBBLE_QUAD.X1], _quad[SCRIBBLE_QUAD.X2], _quad[SCRIBBLE_QUAD.X3])
var _t = min(_quad[SCRIBBLE_QUAD.Y0], _quad[SCRIBBLE_QUAD.Y1], _quad[SCRIBBLE_QUAD.Y2], _quad[SCRIBBLE_QUAD.Y3])
var _r = max(_quad[SCRIBBLE_QUAD.X0], _quad[SCRIBBLE_QUAD.X1], _quad[SCRIBBLE_QUAD.X2], _quad[SCRIBBLE_QUAD.X3])
var _b = max(_quad[SCRIBBLE_QUAD.Y0], _quad[SCRIBBLE_QUAD.Y1], _quad[SCRIBBLE_QUAD.Y2], _quad[SCRIBBLE_QUAD.Y3])
var _w = 1 + _r - _l;
var _h = 1 + _b - _t;

return [_l, _t, _r, _b, _w, _h];