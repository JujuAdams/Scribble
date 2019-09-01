/// Draws a Scribble data structure created with scribble_create()
///
/// @param x         The x position in the room to draw at. Defaults to 0
/// @param y         The y position in the room to draw at. Defaults to 0
/// @param string    The Scribble data structure to be drawn. See scribble_create()
/// @param [xscale]  The horizontal scaling of the text. Defaults to the value set in __scribble_config()
/// @param [yscale]  The vertical scaling of the text. Defaults to the value set in __scribble_config()
/// @param [angle]   The rotation of the text. Defaults to the value set in __scribble_config()
/// @param [colour]  The blend colour for the text. Defaults to draw_get_colour()
/// @param [alpha]   The alpha blend for the text. Defaults to draw_get_alpha()
///
/// All optional arguments accept <undefined> to indicate that the default value should be used.

var _x      = argument[0];
var _y      = argument[1];
var _string = argument[2];
var _xscale = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : SCRIBBLE_DEFAULT_XSCALE;
var _yscale = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : SCRIBBLE_DEFAULT_YSCALE;
var _angle  = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : SCRIBBLE_DEFAULT_ANGLE;
var _colour = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : draw_get_colour();
var _alpha  = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : draw_get_alpha();

return scribble_draw_text_ext(_x, _y, _string, -1, -1, _xscale, _yscale, _angle, _colour, _alpha);