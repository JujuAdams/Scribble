/// Sets Scribble's MSDF drop shadow colour and offset
/// 
/// @param colour    Colour to use for the drop shadow
/// @param alpha     Alpha to use for the drop shadow
/// @param xOffset   x
/// @param yOffset   y
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

var _colour = argument0;
var _alpha  = argument1;
var _x      = argument2;
var _y      = argument3;

if (is_string(_colour))
{
    _colour = global.__scribble_colours[? _colour];
    if (_colour == undefined)
    {
        show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
        exit;
    }
}

global.scribble_state_shadow_color    = _colour;
global.scribble_state_shadow_alpha    = _alpha;
global.scribble_state_shadow_x_offset = _x;
global.scribble_state_shadow_y_offset = _y;