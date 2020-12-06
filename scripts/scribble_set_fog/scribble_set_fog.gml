/// Sets Scribble's fogging colour
/// 
/// @param colour   Fog colour used when drawing text
/// @param alpha    Blending facotr, 0 being un-fogged and and 1 being fully fogged
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until
/// they're overwritten, either by calling this script again or by calling scribble_reset() or scribble_set_state().

function scribble_set_fog(_colour, _alpha)
{
    if (is_string(_colour))
    {
        _colour = global.__scribble_colours[? _colour];
        if (_colour == undefined)
        {
            show_error("Scribble:\nColour name \"" + string(_colour) + "\" not recognised\n ", false);
            exit;
        }
    }
    
    global.scribble_state_fog_colour = _colour;
    global.scribble_state_fog_alpha  = _alpha;
}