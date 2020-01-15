/// Gets the position of the bounding box for a text element.
/// 
/// 
/// Returns: a 4-element array containing the positions of the bounding box for a text element
/// @param string(orElement)   The text to get the bounding box for. Alternatively, you can pass a text element into this argument from a previous call to scribble_draw().
/// @param x                   The x position in the room to draw at. Defaults to 0
/// @param y                   The y position in the room to draw at. Defaults to 0
/// @param [leftMargin]        The additional space to add to the left-hand side of the box. Positive values create more space. Defaults to 0
/// @param [topMargin]         The additional space to add to the top of the box. Positive values create more space. Defaults to 0
/// @param [rightMargin]       The additional space to add to the right-hand side of the box. Positive values create more space. Defaults to 0
/// @param [bottomMargin]      The additional space to add to the bottom of the box. Positive values create more space. Defaults to 0
/// 
/// All optional arguments accept <undefined> to indicate that the default value should be used.

enum SCRIBBLE_BBOX
{
    L, T, R, B,
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
return [min(_quad[SCRIBBLE_QUAD.X0], _quad[SCRIBBLE_QUAD.X1], _quad[SCRIBBLE_QUAD.X2], _quad[SCRIBBLE_QUAD.X3]),
        min(_quad[SCRIBBLE_QUAD.Y0], _quad[SCRIBBLE_QUAD.Y1], _quad[SCRIBBLE_QUAD.Y2], _quad[SCRIBBLE_QUAD.Y3]),
        max(_quad[SCRIBBLE_QUAD.X0], _quad[SCRIBBLE_QUAD.X1], _quad[SCRIBBLE_QUAD.X2], _quad[SCRIBBLE_QUAD.X3]),
        max(_quad[SCRIBBLE_QUAD.Y0], _quad[SCRIBBLE_QUAD.Y1], _quad[SCRIBBLE_QUAD.Y2], _quad[SCRIBBLE_QUAD.Y3])];