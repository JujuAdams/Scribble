// Feather disable all

/// @param font
/// @param state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    //FIXME - This needs to update the font material
    
    __scribble_get_font_data(_font).__bilinear = _state;
}
