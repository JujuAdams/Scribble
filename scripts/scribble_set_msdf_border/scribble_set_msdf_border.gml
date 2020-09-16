/// Sets Scribble's MSDF border
/// 
/// @param colour      Colour to use for the border
/// @param thickness   Thickness of the border, in pixels
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

var _colour    = argument0;
var _thickness = argument1;

if (is_string(_colour))
{
    _colour = global.__scribble_colours[? _colour];
    if (_colour == undefined)
    {
        show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
        exit;
    }
}

global.scribble_state_border_color     = _colour;
global.scribble_state_border_thickness = _thickness;