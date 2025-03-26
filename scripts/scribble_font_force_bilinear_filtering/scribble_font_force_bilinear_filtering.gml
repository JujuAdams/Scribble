// Feather disable all

/// @param {String} fontName
/// @param {Real.Int} state

function scribble_font_force_bilinear_filtering(_font, _state)
{
    __scribble_get_font_data(_font).__bilinear = _state;
}
