/// Sets the starting text format for Scribble
/// 
/// @param fontName     Name of the starting font, as a string. This is the font that is set when [/] or [/font] is used in a string
/// @param fontColor    Starting colour
/// @param textHAlign   Starting horizontal alignment of text
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until they're overwritten, either by
/// calling this script again or by calling scribble_reset() or scribble_set_state().

var _name   = argument0;
var _colour = argument1;
var _halign = argument2;

if (is_string(_name))
{
    global.scribble_state_starting_font = _name;
}
else if (!is_undefined(_name))
{
    show_error("Scribble:\nFonts should be specified using their name as a string\nUse <undefined> to not set a new font\n ", false);
}

if (_colour != undefined)
{
    if (is_string(_colour))
    {
        _colour = global.__scribble_colours[? _colour];
        if (_colour == undefined)
        {
            show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
        }
    }
    
    if ((_colour != undefined) && (_colour >= 0)) global.scribble_state_starting_color = _colour;
}

if ((_halign != undefined) && (_halign >= 0))
{
    global.scribble_state_starting_halign = _halign;
}

global.__scribble_cache_string = string(global.scribble_state_starting_font  ) + ":" +
                                 string(global.scribble_state_starting_color ) + ":" +
                                 string(global.scribble_state_starting_halign) + ":" +
                                 string(global.scribble_state_line_min_height) + ":" +
                                 string(global.scribble_state_line_max_height) + ":" +
                                 string(global.scribble_state_max_width      ) + ":" +
                                 string(global.scribble_state_max_height     ) + ":" +
                                 string(global.scribble_state_character_wrap );